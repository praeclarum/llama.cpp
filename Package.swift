// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "llama",
    platforms: [
        .macOS(.v12),
        .iOS(.v16),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "llama", targets: ["llama"]),
    ],
    targets: [
        .target(
            name: "llama",
            path: ".",
            exclude: [],
            sources: [
                "ggml.c",
                "llama.cpp",
                "ggml-alloc.c",
                "ggml-backend.c",
                "ggml-quants.c",
                "common/common.cpp",
                "common/grammar-parser.cpp",
                "common/sampling.cpp",
                "common/train.cpp",
                "ggml-metal.m",
            ],
            resources: [
                .process("ggml-metal.metal")
            ],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3", "-DNDEBUG"]),
                .unsafeFlags(["-fno-objc-arc"]),
                .define("SWIFT_PACKAGE"),
                .define("GGML_USE_METAL"),
                .define("GGML_USE_ACCELERATE"),
                // NOTE: NEW_LAPACK requires iOS version 16.4+
                .define("ACCELERATE_NEW_LAPACK"),
                // NOTE: ILP64 gets rejected from the app store
                // .define("ACCELERATE_LAPACK_ILP64"),
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
