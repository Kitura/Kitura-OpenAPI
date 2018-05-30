<p align="center">
<a href="http://kitura.io/">
<img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
</a>
</p>


<p align="center">
<a href="http://www.kitura.io/">
<img src="https://img.shields.io/badge/docs-kitura.io-1FBCE4.svg" alt="Docs">
</a>
<a href="https://travis-ci.org/IBM-Swift/Kitura-OpenAPI">
<img src="https://travis-ci.org/IBM-Swift/Kitura-OpenAPI.svg?branch=master" alt="Build Status - Master">
</a>
<img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
<img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
<img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
<a href="http://swift-at-ibm-slack.mybluemix.net/">
<img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
</a>
</p>

# Kitura-OpenAPI

## Summary

Kitura-OpenAPI is a library which makes it easy to add [OpenAPI](https://www.openapis.org/) (aka Swagger) support to your Codable routing-based [Kitura](https://github.com/IBM-Swift/Kitura) application.

By using Kitura-OpenAPI you can:

1. Host an automatically generated OpenAPI definition of your application on a defined endpoint, for example `/openapi`.
2. Host the SwaggerUI tool on a defined endpoint, for example `/openapi/ui`.

## Getting Started

Add Kitura-OpenAPI as a dependency to your Kitura application's `Package.swift` file.

Then import the package inside your application:

```swift
import KituraOpenAPI
```

## Example

Inside your application, add a call to `KituraOpenAPI.addEndpoints(on:with:)` during startup, passing through the Kitura `Router` that you want to host the OpenAPI endpoints on. The `with` parameter optionally allows you to configure where the endpoints are hosted.

For example:

```swift
KituraOpenAPI.addEndpoints(on: router) // Use the default endpoints
```

You can then visit `/openapi` in a web browser to view the generated OpenAPI definition, and `/openapi/ui` to view SwaggerUI.

If you wish, you can customize the endpoint paths:

```swift
let config = KituraOpenAPIConfig(apiPath: "/swagger", swaggerUIPath: "/swagger/ui")
KituraOpenAPI.addEndpoints(on: router, with: config)
```

## More information

Kitura-OpenAPI works by using Kitura's ability to introspect the registered Codable routes at runtime. This feature was added in Kitura 2.4. Hence, if you are not using Codable routing you unfortunately cannot take advantage of this feature. This is because only Codable routes provide the strong type information required in order to generate an OpenAPI definition at runtime.

## Community

We love to talk server-side Swift and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/IBM-Swift/Kitura-OpenAPI/blob/master/LICENSE)
