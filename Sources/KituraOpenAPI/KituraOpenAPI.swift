/*
 * Copyright IBM Corporation 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Kitura
import LoggerAPI
import Foundation

public class KituraOpenAPI {
    public static var defaultConfig = KituraOpenAPIConfig(apiPath: "/openapi", swaggerUIPath: "/openapi/ui")
    public static func addEndpoints(to router: Router, with config: KituraOpenAPIConfig = KituraOpenAPI.defaultConfig) {
        Log.verbose("Registering OpenAPI endpoints")

        // Register OpenAPI serving
        addOpenAPI(to: router, with: config)

        // Register SwaggerUI serving
        addSwaggerUI(to: router, with: config)
    }

    private static func addOpenAPI(to router: Router, with config: KituraOpenAPIConfig) {
        guard let path = config.apiPath else {
            Log.verbose("No path for OpenAPI definition")
            return
        }

        var apipath = path
        if apipath.hasPrefix("/") == false {
            apipath = "/" + apipath
        }

        router.get(apipath) {
            request, response, next in

            guard let json = router.swaggerJSON else {
                Log.warning("Could not retrieve OpenAPI definition from router")
                response.status(.internalServerError)
                try response.send("Could not generate OpenAPI definition").end()
                return
            }

            response.headers.setType("json")
            response.status(.OK)
            try response.send(json).end()
        }
            
        Log.info("Registered OpenAPI definition on \(path)")
    }

    public static func writeOpenAPI(from router: Router, to filePath: String) {
        let swaggerJson = router.swaggerJSON
        do {
            try swaggerJson?.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            Log.error(error.localizedDescription)
        }
    }

    private static func addSwaggerUI(to router: Router, with config: KituraOpenAPIConfig) {
        guard let uiPath = config.swaggerUIPath else {
            Log.verbose("No path for SwaggerUI")
            return
        }

        guard let apiPath = config.apiPath else {
            Log.verbose("No path for OpenAPI definition")
            return
        }

        guard let sourcesDirectory = Utils.localSourceDirectory else {
            Log.error("Could not locate local source directory")
            return
        }

        var aPath = apiPath 
        if aPath.hasPrefix("/") == false {
            aPath = "/" + aPath
        }

        var uPath = uiPath 
        if uPath.hasPrefix("/") == false {
            uPath = "/" + uPath
        }

        let swaggerUIInstallation = sourcesDirectory + "/swaggerui"
        let sourceFileName = "/template.html"
        let destinationFileName = "/index.html"
        
        let sourceFileURL = URL(fileURLWithPath: swaggerUIInstallation + sourceFileName)
        let destinationFileURL = URL(fileURLWithPath: swaggerUIInstallation + destinationFileName)
        
        do {
            var fileContents = try String(contentsOf: sourceFileURL, encoding: .utf8)
            
            fileContents = fileContents.replacingOccurrences(of: "{{openapi}}", with: aPath)
            
            try fileContents.write(to: destinationFileURL, atomically: true, encoding: .utf8)
        } catch {
            Log.error(error.localizedDescription)
        }
        router.get(uPath, middleware: StaticFileServer(path: swaggerUIInstallation))
    }
}
