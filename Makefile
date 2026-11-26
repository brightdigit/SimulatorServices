.PHONY: help build test lint format headers docs docs-preview clean

.DEFAULT_GOAL := help

## build: Build the package
build:
	swift build

## test: Run the test suite
test:
	swift test

## lint: Format, then run swift-format, SwiftLint, the build and periphery (Scripts/lint.sh)
lint:
	@./Scripts/lint.sh

## format: Format sources in place without linting
format:
	@FORMAT_ONLY=1 ./Scripts/lint.sh

## headers: Add or refresh the license header in Sources
headers:
	@./Scripts/header.sh -d Sources -c "Leo Dion" -o "BrightDigit" -p "SimulatorServices"

## docs: Build the DocC archive (.build/docs); fails on unresolved symbol links
docs:
	@./Scripts/docc.sh

## docs-preview: Serve a live DocC preview
docs-preview:
	@DOCC_PREVIEW=1 ./Scripts/docc.sh

## clean: Remove build products
clean:
	swift package clean
	rm -rf .build DerivedData

## help: Show this help
help:
	@echo "SimulatorServices targets:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/ /'
	@echo ""
	@echo "Lint tools are pinned in mise.toml; run 'mise install' once."
