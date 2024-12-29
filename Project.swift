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
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen" // 런치 스토리보드 설정
                    // UIApplicationSceneManifest 제거
                ]
            ),
            sources: ["\(projectName)/Sources/**"],
            resources: ["\(projectName)/Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "CombineCocoa"),
                .external(name: "Kingfisher"),
                .external(name: "Moya"),
                .external(name: "CombineMoya"),
                .external(name: "Swinject"),
            ] // tuist generate할 경우 pod install이 자동으로 실행
           ),
    .target(name: projectName + "Tests",
            destinations: [.iPhone],
            //           platform: .iOS,
            product: .unitTests, // unitTests, .appExtension, .framework, dynamicLibrary, staticFramework
            bundleId: bundleID + "Tests",
            deploymentTargets: .iOS("\(targetVersion)"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen" // 런치 스토리보드 설정
                    // UIApplicationSceneManifest 제거
                ]
            ),
            sources: ["\(projectName)/**"],
            dependencies: [
                .target(name: projectName),
                .external(name: "Quick"),
                .external(name: "Nimble"),
            ] // tuist generate할 경우 pod install이 자동으로 실행
           ),
  ]
)
