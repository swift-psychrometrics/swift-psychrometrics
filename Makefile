DOCC_BUILD_PATH := /tmp/swift-web-playground-build
LLVM_PATH := /usr/local/opt/llvm/bin/llvm-cov
BIN_PATH = $(shell swift build --show-bin-path)
XCTEST_PATH = $(shell find $(BIN_PATH) -name '*.xctest')
COV_BIN := .build/debug/swift-psychrometricsPackageTests.xctest/Contents/MacOS/swift-psychrometricsPackageTests
COV_OUTPUT_PATH = "/tmp/swift-psychrometrics.lcov"
DOCKER_PLATFORM ?= linux/arm64

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

test-all: test test-linux

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
