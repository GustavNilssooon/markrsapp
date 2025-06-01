// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "markrsapp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "markrsapp",
            targets: ["markrsapp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "markrsapp",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ]),
        .testTarget(
            name: "markrsappTests",
            dependencies: ["markrsapp"]),
    ]
) 