#!/usr/bin/env bash
set -euo pipefail

create_image() {
    local TEMPLATE=$1
    local VARIANT=$2

    # Validate inputs
    if [ -z "$TEMPLATE" ] || [ -z "$VARIANT" ]; then
        echo "Error: TEMPLATE and VARIANT must be set"
        exit 1
    fi

    # Define project directories
    local SRC_DIR
    SRC_DIR=$(dirname "$(realpath "$0")")
    local SRC_PATH="$SRC_DIR/../src/$TEMPLATE"
    # local TARGET_DIR="$SRC_DIR/../dist/${TEMPLATE}/${VARIANT}"
    local TARGET_DIR="dist/${TEMPLATE}/${VARIANT}"

    # Check if the source directory exists
    if [ ! -d "$SRC_PATH" ]; then
        echo "Error: Source directory $SRC_PATH does not exist"
        exit 1
    fi

    # Create target directory if it doesn't exist
    echo "Preparing target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"

    # Copy content from the source directory to the target directory using rsync
    echo "Copying files from $SRC_PATH to $TARGET_DIR"
    rsync -a --exclude 'variants.json' "$SRC_PATH"/ "$TARGET_DIR"/

    # Replace the placeholder with the variant provided in devcontainer.json, if exists
    local DEVCONTAINER_JSON="$TARGET_DIR/.devcontainer/devcontainer.json"
    if [ -f "$DEVCONTAINER_JSON" ]; then
        echo "Updating devcontainer.json with variant: $VARIANT"
        sed -i -e "s/__VARIANT__/${VARIANT}/g" "$DEVCONTAINER_JSON"
    else
        echo "Warning: $DEVCONTAINER_JSON not found, skipping variant substitution"
    fi

    echo "Build process complete for template: $TEMPLATE, variant: $VARIANT."
}

create_variant_matrix() {
    local VARIANT_MATRIX_FILE="dist/variant-matrix.json"
    local TEMPLATE VARIANT TEMPLATES VARIANTS

    # Initialize the variant-matrix.json file with an empty array
    echo '{ "variants": [] }' > "$VARIANT_MATRIX_FILE"
  
    # Get a list of templates (directories in dist)
    TEMPLATES=$(find dist -mindepth 1 -maxdepth 1 -type d -printf "%f\n")

    # Initialize an array to collect JSON objects
    variant_items=()

    for TEMPLATE in $TEMPLATES; do
        # Get a list of variants (subdirectories in each template folder)
        VARIANTS=$(find dist/"$TEMPLATE" -mindepth 1 -maxdepth 1 -type d -printf "%f\n")
        
        for VARIANT in $VARIANTS; do
            # Create a JSON object with TEMPLATE and VARIANT attributes
            variant_items+=("{\"TEMPLATE\": \"$TEMPLATE\", \"VARIANT\": \"$VARIANT\"}")
        done
    done

    # Write the accumulated JSON objects to the JSON file in one operation
    jq --argjson variants "$(printf '%s\n' "${variant_items[@]}" | jq -s '.')" \
       '.variants = $variants' \
       "$VARIANT_MATRIX_FILE" > tmp.json && mv tmp.json "$VARIANT_MATRIX_FILE"
}