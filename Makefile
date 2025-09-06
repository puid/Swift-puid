# Make common tasks easy

SWIFT_FORMAT=swift-format
SWIFTLINT=swiftlint

FMT_PATHS=Sources Tests
FMT_CFG=.swift-format

.PHONY: fmt fmt-check lint bootstrap

# Format sources and tests in-place
fmt:
	$(SWIFT_FORMAT) format --configuration $(FMT_CFG) --in-place --recursive $(FMT_PATHS)

# Check formatting without modifying files (CI-friendly)
fmt-check:
	$(SWIFT_FORMAT) lint --configuration $(FMT_CFG) --recursive $(FMT_PATHS)

# Run SwiftLint with repo-config
lint:
	$(SWIFTLINT) lint

# Install Mint packages from Mintfile
bootstrap:
	mint bootstrap

