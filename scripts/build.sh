#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/utils.sh"

TEMPLATES=$(find src -mindepth 1 -maxdepth 1 -type d -printf "%f\n")

for TEMPLATE in $TEMPLATES; do
    VARIANTS_FILE="src/${TEMPLATE}/variants.json"

    # Check if the variants file exists
    if [[ ! -f "$VARIANTS_FILE" ]]; then
        echo "Error: Variants file $VARIANTS_FILE not found."
        exit 1
    fi

    # Extract the array from the JSON file using jq
    VARIANTS=$(jq -r '.variants[]' "$VARIANTS_FILE")

    # Iterate over each variant and create an image
    while IFS= read -r VARIANT; do
        create_image "$TEMPLATE" "$VARIANT"
    done <<< "$VARIANTS"
done

echo "Images creation process complete."

# Generate the variant-matrix.json file for the pipeline automation
create_variant_matrix
