CONFIG = debug
DOCC_TARGET := PsychrometricClient
PLATFORM_IOS = iOS Simulator,name=iPhone 15,OS=17.0
PLATFORM_MACOS = macOS
PLATFORM_MAC_CATALYST = macOS,variant=Mac Catalyst
PLATFORM_TVOS = tvOS Simulator,id=$(call udid_for,tvOS,TV)
PLATFORM_WATCHOS = watchOS Simulator,id=$(call udid_for,watchOS,Watch)
SCHEME := swift-psychrometrics-Package
DOCKER_SWIFT_VERSION := 6.0

default: test-swift

.PHONY: build-all-platforms
build-all-platforms:
	for platform in \
		"$(PLATFORM_IOS)" \
		"$(PLATFORM_MACOS)" \
		"$(PLATFORM_MAC_CATALYST)" \
		"$(PLATFORM_TVOS)" \
		"$(PLATFORM_WATCHOS)"; \
	do \
		xcrun xcodebuild build \
			-scheme "$(SCHEME)" \
			-configuration $(CONFIG) \
			-destination platform="$$platform" || exit 1; \
	done;

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
		swift:$(DOCKER_SWIFT_VERSION) \
		swift package clean && swift test

.PHONY: format
format:
	swift format \
		--in-place \
		--recursive \
		./Package.swift \
		./Sources \
		./Tests

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

.PHONY: preview-shared-models-documentation
preview-shared-models-documentation:
	swift package \
		--disable-sandbox \
		preview-documentation \
		--target SharedModels

# Stolen from https://github.com/pointfreeco/swift-composable-architecture/blob/main/Makefile
 define udid_for
$(shell xcrun simctl list devices available '$(1)' | grep '$(2)' | sort -r | head -1 | awk -F '[()]' '{ print $$(NF-3) }')
endef
