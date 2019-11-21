# Standard automation etc for the tool

OUTPUT_DIR = .build
RELEASE_DIR = $(OUTPUT_DIR)/release

.PHONY: cleanup build

build: cleanup
	swift build -c release
	@mv $(RELEASE_DIR) ./release
	@echo "Job's Done!  🤓"

cleanup:
	rm -rf .build
	-rm -rf Package.resolved

