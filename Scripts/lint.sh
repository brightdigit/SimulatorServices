#!/bin/bash
#
# Formats and lints SimulatorServices: swift-format, SwiftLint, a build of every target
# (tests included), the license header, and periphery (locally only).
#
# Outside CI it first formats in place (swift-format format, swiftlint --fix).
# Every lint tool runs strict, so a warning fails its step; the script keeps
# going and exits non-zero if any step failed.
#
#   FORMAT_ONLY=1      only format (skips lint, build and periphery)

# Keep running after a failed step; ERRORS counts them.
ERRORS=0

run_command() {
	"$@" || ERRORS=$((ERRORS + 1))
}

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PACKAGE_DIR="${SCRIPT_DIR}/.."

# Put the mise-pinned tools on PATH outside CI (CI uses jdx/mise-action).
# Skipped in Claude Code web sessions, which can't reach the GitHub API that
# mise's spm/aqua backends need.
if command -v mise >/dev/null 2>&1 && [ -z "$CI" ] \
	&& [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
	eval "$(mise -C "$PACKAGE_DIR" env -s bash)"
fi

# SwiftLint and periphery aren't available in Claude Code web sessions;
# swift-format ships with the toolchain, so formatting and the build still run.
if [ "${CLAUDE_CODE_REMOTE:-}" = "true" ]; then
	RUN_SWIFTLINT=0
else
	RUN_SWIFTLINT=1
fi

SWIFTFORMAT_FORMAT_OPTIONS="--configuration .swift-format"
SWIFTFORMAT_LINT_OPTIONS="--configuration .swift-format --strict"
SWIFTLINT_OPTIONS="--strict"
PERIPHERY_OPTIONS="--strict"

pushd "$PACKAGE_DIR" >/dev/null || exit

if [ -z "$CI" ]; then
	run_command swift-format format $SWIFTFORMAT_FORMAT_OPTIONS \
		--recursive --parallel --in-place Sources Tests
	if [ "$RUN_SWIFTLINT" -eq 1 ]; then
		run_command swiftlint --fix
	fi
fi

if [ -z "$FORMAT_ONLY" ]; then
	run_command swift-format lint --recursive --parallel \
		$SWIFTFORMAT_LINT_OPTIONS Sources Tests

	if [ "$RUN_SWIFTLINT" -eq 1 ]; then
		run_command swiftlint lint $SWIFTLINT_OPTIONS
	else
		echo "Skipping SwiftLint (Claude Code web session)."
	fi

	# CI's lint job runs on a stock Ubuntu runner whose Swift may be older than
	# the manifest's 6.4; the build jobs already compile everything there.
	if [ -z "$CI" ]; then
		run_command swift build --build-tests
	fi
fi

# Keeps each file's license header current (an existing header keeps its year).
"$PACKAGE_DIR/Scripts/header.sh" -d "$PACKAGE_DIR/Sources" \
	-c "Leo Dion" -o "BrightDigit" -p "SimulatorServices"

# Periphery can't find the index store on its own: the path depends on the
# build system (`.build/out` for swiftbuild, `.build/<triple>/debug/index/store`
# for the native one). `--index-store-path` implies `--skip-build`, which is
# what we want after `swift build --build-tests` above. Local only: CI has
# never run it, and it has no Linux binaries.
periphery_index_store() {
	local candidate
	for candidate in "$PACKAGE_DIR"/.build/*/debug/index/store \
		"$PACKAGE_DIR"/.build/debug/index/store \
		"$PACKAGE_DIR"/.build/out; do
		# .build/index-build is SourceKit-LSP's background index, not this build.
		case "$candidate" in */.build/index-build/*) continue ;; esac
		if [ -d "$candidate/v5/units" ]; then
			printf '%s\n' "$candidate"
			return 0
		fi
	done
	return 1
}

if [ -z "$FORMAT_ONLY" ] && [ -z "$CI" ] \
	&& [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
	if ! command -v periphery >/dev/null 2>&1; then
		echo "Skipping periphery scan (not installed; run 'mise install')."
	elif INDEX_STORE_PATH=$(periphery_index_store); then
		run_command periphery scan $PERIPHERY_OPTIONS \
			--index-store-path "$INDEX_STORE_PATH" --skip-build \
			--disable-update-check
	else
		echo "Skipping periphery scan (no index store under .build)."
	fi
fi

popd >/dev/null || exit

if [ $ERRORS -gt 0 ]; then
	echo "Linting completed with $ERRORS error(s)"
	exit 1
else
	echo "Linting completed successfully"
	exit 0
fi
