# Standard automation etc for the tool

OUTPUT_DIR = .build/x86_64-unknown-linux
RELEASE_DIR = $(OUTPUT_DIR)/release
TESTING_DIR = $(OUTPUT_DIR)/debug

.PHONY: cleanup release buildAndTest

release: cleanup
	rm -rf ./.build
	-rm -rf ./release
	-rm -rf ./Package.resolved
	swift build -c release
	@mv $(RELEASE_DIR) ./release
	@echo "Job's Done!  🤓"

cleanup:
	@echo "Standard cleanup..."

buildAndTest: cleanup
	swift build
	swift run SwiftCodeHelperDemo
