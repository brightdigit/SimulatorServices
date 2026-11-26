#!/bin/bash
#
# Builds SimulatorServices's DocC documentation without the swift-docc-plugin
# dependency: `swift package dump-symbol-graph` emits the symbol graph, then
# `docc convert` renders the catalog. Keeping the plugin out of Package.swift
# means packages that depend on SimulatorServices never resolve it.
#
# Usage:
#   ./Scripts/docc.sh                  # build .build/docs/SimulatorServices.doccarchive
#   DOCC_STATIC_HOSTING=1 ./Scripts/docc.sh   # also transform for static hosting
#   DOCC_HOSTING_BASE_PATH=SimulatorServices ...       # base path for GitHub Pages
#   DOCC_PREVIEW=1 ./Scripts/docc.sh   # serve a live preview instead
#
# Warnings (including unresolved symbol links) fail the build.

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PACKAGE_DIR="${SCRIPT_DIR}/.."
TARGET="SimulatorServices"

cd "$PACKAGE_DIR"

if [ "$(uname)" = "Darwin" ]; then
	DOCC=(xcrun docc)
else
	DOCC=(docc)
fi

OUTPUT_DIR=".build/docs"
ARCHIVE="${OUTPUT_DIR}/${TARGET}.doccarchive"
SYMBOL_GRAPH_DIR="${OUTPUT_DIR}/symbol-graphs"

rm -rf "$SYMBOL_GRAPH_DIR" "$ARCHIVE"
mkdir -p "$SYMBOL_GRAPH_DIR"

# The output folder depends on the build system (.build/out/symbolgraph with
# swiftbuild, .build/<triple>/symbolgraph with the native one), so read it
# from SwiftPM's own message.
DUMP_LOG=$(swift package dump-symbol-graph --minimum-access-level public 2>&1) || {
	echo "$DUMP_LOG" >&2
	exit 1
}
DUMP_DIR=$(printf '%s\n' "$DUMP_LOG" | sed -n 's/^Files written to //p' | tail -n 1)
if [ -z "$DUMP_DIR" ] || [ ! -d "$DUMP_DIR" ]; then
	echo "$DUMP_LOG" >&2
	echo "error: couldn't find the symbol graph output folder" >&2
	exit 1
fi

# Keep only this target's graphs (dependencies' and Foundation's aren't ours).
cp "$DUMP_DIR/${TARGET}.symbols.json" "$SYMBOL_GRAPH_DIR/"
find "$DUMP_DIR" -maxdepth 1 -name "${TARGET}@*.symbols.json" \
	-exec cp {} "$SYMBOL_GRAPH_DIR/" \;

COMMON_ARGS=(
	"Sources/${TARGET}/Documentation.docc"
	--fallback-display-name "$TARGET"
	--fallback-bundle-identifier "com.brightdigit.${TARGET}"
	--additional-symbol-graph-dir "$SYMBOL_GRAPH_DIR"
)

if [ -n "${DOCC_PREVIEW:-}" ]; then
	exec "${DOCC[@]}" preview "${COMMON_ARGS[@]}"
fi

"${DOCC[@]}" convert "${COMMON_ARGS[@]}" \
	--warnings-as-errors \
	--output-path "$ARCHIVE"

if [ -n "${DOCC_STATIC_HOSTING:-}" ]; then
	"${DOCC[@]}" process-archive transform-for-static-hosting "$ARCHIVE" \
		--output-path "${OUTPUT_DIR}/site" \
		${DOCC_HOSTING_BASE_PATH:+--hosting-base-path "$DOCC_HOSTING_BASE_PATH"}
	echo "Static site: ${OUTPUT_DIR}/site"
fi

echo "Documentation archive: ${ARCHIVE}"
