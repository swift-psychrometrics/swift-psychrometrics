PLATFORM_IOS = iOS Simulator,name=iPhone 14,OS=16.2
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
CONFIG = debug
DOCC_BUILD_PATH := /tmp/swift-web-playground-build
LLVM_PATH := /usr/local/opt/llvm/bin/llvm-cov
BIN_PATH = $(shell swift build --show-bin-path)
XCTEST_PATH = $(shell find $(BIN_PATH) -name '*.xctest')
COV_BIN := .build/debug/swift-psychrometricsPackageTests.xctest/Contents/MacOS/swift-psychrometricsPackageTests
COV_OUTPUT_PATH = "/tmp/swift-psychrometrics.lcov"
DOCKER_PLATFORM ?= linux/arm64
SCHEME := swift-psychrometrics-Package

test:
	swift test --enable-code-coverage

test-linux:
	@docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		--platform $(DOCKER_PLATFORM) \
		swift:5.7-focal \
		swift package clean && swift test

test-server:
	for platform in "$(PLATFORM_MACOS)"; do \
		xcodebuild test \
			-configuration $(CONFIG) \
			-workspace .swiftpm/xcode/package.xcworkspace \
			-scheme "$(SCHEME)" \
			-destination platform="$$platform" || exit 1; \
	done

test-psychrometrics:
	for platform in "$(PLATFORM_IOS)"; do \
		xcodebuild test \
			-configuration $(CONFIG) \
			-workspace .swiftpm/xcode/package.xcworkspace \
			-scheme "$(SCHEME)" \
			-destination platform="$$platform" || exit 1; \
	done

test-library:
	$(MAKE) CONFIG=debug test-server
	$(MAKE) CONFIG=release test-server
	$(MAKE) CONFIG=debug test-psychrometrics
	$(MAKE) CONFIG=release test-psychrometrics


test-all: test-linux test-library

format:
	swift format \
		--in-place \
		--recursive \
		./Package.swift \
		./Sources/

code-cov:
	@rm -rf $(COV_OUTPUT_PATH)
	@xcrun llvm-cov export \
		$(COV_BIN) \
		-instr-profile=.build/debug/codecov/default.profdata \
		-ignore-filename-regex=".build|Tests" \
		-format lcov > $(COV_OUTPUT_PATH)

code-cov-report: test
	@xcrun llvm-cov report \
		$(COV_BIN) \
		-instr-profile=.build/debug/codecov/default.profdata \
		-use-color

cli:
	@swift package clean \
		&& PSYCHROMETRIC_CLI_ENABLED=1 swift build -c release
	@open .build/release

clean:
	rm -rf .build/*
