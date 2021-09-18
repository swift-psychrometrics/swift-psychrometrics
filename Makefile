
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
