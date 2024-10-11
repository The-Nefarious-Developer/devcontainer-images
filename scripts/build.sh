#!/usr/bin/env bash

SRC_DIR=$(dirname "$0")
TARGET_DIR="dist/${TEMPLATE}/${VARIANT}"

# Create a brand new target directory
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Copy content from the source directory to the build directory for further processing
cp -R "$SRC_DIR"/../src/"$TEMPLATE"/. "$TARGET_DIR"

# Simulate a --build-args behavior by replacing the image variant
# with the version provided by github actions.
sed -i -e "s/\__VARIANT__/${VARIANT}/g" "$TARGET_DIR"/.devcontainer/devcontainer.json