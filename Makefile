# Standard automation etc for the tool

SRC_DIR = Sources
C_SRC_DIR = $(SRC_DIR)/cSwiftCodeDisplay
OUTPUT_DIR = .build/x86_64-unknown-linux
RELEASE_DIR = $(OUTPUT_DIR)/release
TESTING_DIR = $(OUTPUT_DIR)/debug
C_OUTPUT_DIR = cBuild
LINKER_FLAGS = -lm -lSDL2

.PHONY: cleanup release buildAndTest cModuleTest cCleanup

release: cleanup
	rm -rf ./.build
	-rm -rf ./release
	-rm -rf ./Package.resolved
	swift build -c release
	@mv $(RELEASE_DIR) ./release
	@echo "Job's Done!  🤓"

cleanup:
	@echo "Standard cleanup..."
	-rm Package.resolved

buildAndTest: cleanup
	swift build
	swift run SwiftCodeHelperDemo -f ./testResources/swift/

cModuleTest: cCleanup
	gcc -Wall -o $(C_OUTPUT_DIR)/cTest $(C_SRC_DIR)/cSwiftCodeDisplay.c $(LINKER_FLAGS)
	$(C_OUTPUT_DIR)/cTest

cCleanup:
	@echo "Prep for C code testing"
	-rm -rf $(C_OUTPUT_DIR)
	mkdir $(C_OUTPUT_DIR)