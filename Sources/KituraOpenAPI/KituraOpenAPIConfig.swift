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

/// Defines the endpoints for the OpenAPI document and SwaggerUI tool when used
/// in conjunction with `KituraOpenAPI.addEndpoints(to:with:)`.
public struct KituraOpenAPIConfig {
    /// Path to serve OpenAPI specification from. If nil, do not serve.
    public let apiPath: String?

    /// Path to serve SwaggerUI from. If nil, do not serve.
    public let swaggerUIPath: String?
    
    /// Create a `KituraOpenAPIConfig` with custom endpoints.
    /// - Parameter apiPath: Path to serve OpenAPI specification from. If nil, do not serve.
    /// - Parameter swaggerUIPath: Path to serve SwaggerUI from. If nil, do not serve.
    public init(apiPath: String?, swaggerUIPath: String?) {
        self.apiPath = apiPath
        self.swaggerUIPath = swaggerUIPath
    }
}
