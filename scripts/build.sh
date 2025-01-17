#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$(dirname "$0")/utils.sh"

# Get all directories in src (avoid using find if not needed)
IMAGES=(src/*/)

for IMAGE in "${IMAGES[@]}"; do
    IMAGE=$(basename "$IMAGE")
    VARIANTS_FILE="src/${IMAGE}/variants.json"

    # Check if the variants file exists
    if [[ ! -f "$VARIANTS_FILE" ]]; then
        echo "Error: Variants file $VARIANTS_FILE not found." >&2
        exit 1
    fi

    # Extract the array from the JSON file using jq, and handle potential errors
    VARIANTS=$(jq -r '.variants[]' "$VARIANTS_FILE" || { echo "Error reading $VARIANTS_FILE"; exit 1; })

    # Iterate over each variant and create an image in parallel
    for VARIANT in $VARIANTS; do
        create_image "$IMAGE" "$VARIANT" &
    done

    # Wait for all background jobs to finish
    wait
done
echo "Images creation process complete."

# Generate the variant-matrix.json file for pipeline automation
create_variant_matrix
