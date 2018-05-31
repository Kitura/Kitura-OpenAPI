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

        router.get(path) {
            request, response, next in

            guard let json = router.swaggerJSON else {
                Log.warning("Could not retrieve OpenAPI definition from router")
                response.send("Could not generate OpenAPI definition")
                return next()
            }

            response.headers.setType("application/json")
            response.send(json)
            next()
        }
        Log.info("Registered OpenAPI definition on \(path)")
    }

    private static func addSwaggerUI(to router: Router, with config: KituraOpenAPIConfig) {
        guard let path = config.swaggerUIPath else {
            Log.verbose("No path for SwaggerUI")
            return
        }
        guard let sourcesDirectory = Utils.localSourceDirectory else {
            Log.error("Could not locate local source directory")
            return
        }

        router.all(path, middleware: StaticFileServer(path: sourcesDirectory + "/swaggerui"))
        Log.info("Registered SwaggerUI on \(path)")
    }
}
