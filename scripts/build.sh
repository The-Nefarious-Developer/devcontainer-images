#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Enable verbose mode for debugging (optional, you can comment this out)
# set -x

# Define directories
SRC_DIR=$(dirname "$0")
TARGET_DIR="dist/${TEMPLATE}/${VARIANT}"

# Check if necessary variables are set
if [ -z "$TEMPLATE" ] || [ -z "$VARIANT" ]; then
    echo "Error: TEMPLATE and VARIANT must be set"
    exit 1
fi

# Check if the source directory exists
SRC_PATH="$SRC_DIR/../src/$TEMPLATE"
if [ ! -d "$SRC_PATH" ]; then
    echo "Error: Source directory $SRC_PATH does not exist"
    exit 1
fi

# Create a brand new target directory
echo "Creating target directory: $TARGET_DIR"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Copy content from the source directory to the target directory
echo "Copying files from $SRC_PATH to $TARGET_DIR"
cp -R "$SRC_PATH"/. "$TARGET_DIR"

# Replace the placeholder with the variant provided
DEVCONTAINER_JSON="$TARGET_DIR/.devcontainer/devcontainer.json"
if [ -f "$DEVCONTAINER_JSON" ]; then
    echo "Updating devcontainer.json with variant: $VARIANT"
    sed -i -e "s/__VARIANT__/${VARIANT}/g" "$DEVCONTAINER_JSON"
else
    echo "Warning: $DEVCONTAINER_JSON not found, skipping variant substitution"
fi

echo "Build process complete."
