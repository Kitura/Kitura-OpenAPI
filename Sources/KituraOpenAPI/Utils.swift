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
 **/

import CloudFoundryEnv
import Configuration
import Foundation
import LoggerAPI

internal struct Utils {
  static var localSourceDirectory: String? {
    let fm = FileManager.default
    let currentDir = fm.currentDirectoryPath
    let configMgr = ConfigurationManager().load(.environmentVariables)
    var applicationPath = ""

    if configMgr.isLocal {
      var workingPath = ""
      if currentDir.contains(".build") {
        ///we're below the Packages directory
        workingPath = currentDir
      } else {
        ///we're above the Packages directory
        workingPath = CommandLine.arguments[0]
      }
      Log.verbose("workingPath=\(workingPath)")

      if let i = workingPath.range(of: ".build") {
        applicationPath = String(workingPath[..<i.lowerBound])
        Log.verbose("applicationPath=\(applicationPath)")
      } else {
        Log.verbose("Error finding .build directory")
      }
    } else {
      // We're in Bluemix, use the path the swift-buildpack saves libraries to
      applicationPath = "/home/vcap/app/"
      Log.verbose("In cloud, applicationPath=\(applicationPath)")
    }

    let checkoutsPath = applicationPath + ".build/checkouts/"
    if fm.fileExists(atPath: checkoutsPath) {
      Log.verbose("checkoutsPath=\(checkoutsPath)")
      _ = fm.changeCurrentDirectoryPath(checkoutsPath)
    } else {
      Log.verbose("Error finding .build/checkouts directory")
    }
    
    do {
      let dirContents = try fm.contentsOfDirectory(atPath: fm.currentDirectoryPath)
      for dir in dirContents {
        if dir.contains("Kitura-OpenAPI") {
          Log.verbose("Found Kitura-OpenAPI package directory")
          _ = fm.changeCurrentDirectoryPath(dir)
        }
      }
    } catch {
      Log.error("Error obtaining contents of directory: \(fm.currentDirectoryPath), \(error).")
    }
    
    let packagePath = "\(fm.currentDirectoryPath)/Package.swift"
    if fm.fileExists(atPath: packagePath) {
      Log.verbose("Found Package.swift, returning \(fm.currentDirectoryPath)")
      return fm.currentDirectoryPath
    } else {
        // could be in Xcode, try source directory
        Log.verbose("Did not find Package.swift, might be running under Xcode")
        let fileName = NSString(string: #file)
        let installDirPrefixRange: NSRange
        let installDir = fileName.range(of: "/Sources/KituraOpenAPI/Utils.swift", options: .backwards)
        if installDir.location != NSNotFound {
          installDirPrefixRange = NSRange(location: 0, length: installDir.location)
        } else {
          installDirPrefixRange = NSRange(location: 0, length: fileName.length)
        }
        let folderName = fileName.substring(with: installDirPrefixRange)
        Log.verbose("folderName=\(folderName)")
        return folderName
    }
  }
}
