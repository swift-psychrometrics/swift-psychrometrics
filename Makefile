DOCC_BUILD_PATH := /tmp/swift-web-playground-build
LLVM_PATH := /usr/local/opt/llvm/bin/llvm-cov
BIN_PATH = $(shell swift build --show-bin-path)
XCTEST_PATH = $(shell find $(BIN_PATH) -name '*.xctest')
COV_BIN := .build/debug/swift-psychrometricsPackageTests.xctest/Contents/MacOS/swift-psychrometricsPackageTests
COV_OUTPUT_PATH = "/tmp/swift-psychrometrics.lcov"

test:
	swift test --enable-code-coverage
	
test-linux:
	@docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		--platform linux/amd64 \
		swift:5.4 \
		swift package clean && swift test
		
test-all: test test-linux
	
format:
	@docker run \
		--rm \
		--workdir "/work" \
		--volume "$(PWD):/work" \
		--platform linux/amd64 \
		mhoush/swift-format:latest \
		format \
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
