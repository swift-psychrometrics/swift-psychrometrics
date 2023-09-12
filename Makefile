PLATFORM_IOS = iOS Simulator,name=iPhone 14,OS=16.2
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
PLATFORM_TVOS = tvOS Simulator,name=Apple TV
PLATFORM_WATCHOS = watchOS Simulator,name=Apple Watch Series 8 (45mm)

CONFIG = debug

DOCC_TARGET := PsychrometricClient

LLVM_PATH := /usr/local/opt/llvm/bin/llvm-cov
BIN_PATH = $(shell swift build --show-bin-path)
XCTEST_PATH = $(shell find $(BIN_PATH) -name '*.xctest')
COV_BIN := .build/debug/swift-psychrometricsPackageTests.xctest/Contents/MacOS/swift-psychrometricsPackageTests
COV_OUTPUT_PATH = "/tmp/swift-psychrometrics.lcov"
DOCKER_PLATFORM ?= linux/arm64
SCHEME := swift-psychrometrics-Package

default: test-swift

.PHONY: test-macos
test-macos: clean
		set -o pipefail && \
		xcodebuild test \
				-scheme "$(SCHEME)" \
				-configuration "$(CONFIG)" \
				-destination platform="$(PLATFORM_MACOS)"

.PHONY: test-ios
test-ios: clean
		set -o pipefail && \
		xcodebuild test \
				-scheme "$(SCHEME)" \
				-configuration "$(CONFIG)" \
				-destination platform="$(PLATFORM_IOS)"

.PHONY: test-mac-catalyst
test-mac-catalyst: clean
		set -o pipefail && \
		xcodebuild test \
				-scheme "$(SCHEME)" \
				-configuration "$(CONFIG)" \
				-destination platform="$(PLATFORM_MAC_CATALYST)"

.PHONY: test-tvos
test-tvos: clean
		set -o pipefail && \
		xcodebuild test \
				-scheme "$(SCHEME)" \
				-configuration "$(CONFIG)" \
				-destination platform="$(PLATFORM_TVOS)"

.PHONY: test-watchos
test-watchos: clean
		set -o pipefail && \
		xcodebuild test \
				-scheme "$(SCHEME)" \
				-configuration "$(CONFIG)" \
				-destination platform="$(PLATFORM_WATCHOS)"

.PHONY: test-swift
test-swift:
	swift test
	swift test -c release

.PHONY: test-linux
test-linux:
	@docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		--platform linux/amd64 \
		swift:5.6 \
		swift package clean && swift test

.PHONY: test-library
test-library: test-macos test-ios test-mac-catalyst test-tvos test-watchos

.PHONY: format
format:
	swift format \
		--in-place \
		--recursive \
		./Package.swift \
		./Sources/

.PHONY: code-cov
code-cov:
	@rm -rf $(COV_OUTPUT_PATH)
	@xcrun llvm-cov export \
		$(COV_BIN) \
		-instr-profile=.build/debug/codecov/default.profdata \
		-ignore-filename-regex=".build|Tests" \
		-format lcov > $(COV_OUTPUT_PATH)

.PHONY: code-cov-report
code-cov-report: test
	@xcrun llvm-cov report \
		$(COV_BIN) \
		-instr-profile=.build/debug/codecov/default.profdata \
		-use-color

.PHONY: clean
clean:
	rm -rf .build/*

.PHONY: build-documentation
build-documentation:
	swift package \
		--allow-writing-to-directory ./docs \
		generate-documentation \
		--target "$(DOCC_TARGET)" \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path "$(SCHEME)" \
		--output-path ./docs

.PHONY: preview-documentation
preview-documentation:
	swift package \
		--disable-sandbox \
		preview-documentation \
		--target "$(DOCC_TARGET)"
