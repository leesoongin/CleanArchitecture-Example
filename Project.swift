import ProjectDescription

// MARK: Constants
let projectName = "SearchSample"
let organizationName = "SearchSample"
let bundleID = "com.search.sample"
let targetVersion = "15.0"

// MARK: Struct
let project = Project(
  name: projectName,
  organizationName: organizationName,
  packages: [],
  settings: nil,
  targets: [
    
    .target(name: projectName,
            destinations: [.iPhone],
            //           platform: .iOS,
            product: .app, // unitTests, .appExtension, .framework, dynamicLibrary, staticFramework
            bundleId: bundleID,
            deploymentTargets: .iOS("\(targetVersion)"),
            infoPlist: .default,
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: [] // tuist generate할 경우 pod install이 자동으로 실행
           )
  ]
)
