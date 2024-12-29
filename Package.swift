// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "CombineCocoa": .framework,
            "CombineExt": .framework
        ]
    )
#endif

let package = Package(
    name: "SearchSample",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/devxoul/Then", exact: "3.0.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: "1.8.1"),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", exact: "0.4.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.7.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", exact: "6.2.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", exact: "7.11.0"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.3"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
         .package(url: "https://github.com/Quick/Nimble.git", from: "12.0.0"),
    ]
)
