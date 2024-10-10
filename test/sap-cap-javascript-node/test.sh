#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../test-utils/harness.sh"

setup "sap-cap-javascript-node" "$VARIANT"

run_test "Node version is correct" "node -v" "$IMAGE_TAG"
run_test "NPM is present" "npm --help" "npm <command>"
run_test "CloudFoundry CLI is present" "cf --version" "cf version 8"
run_test "CAP Development Toolkit is present" "cds version" "@cap-js/asyncapi"
run_test "Container defaults to non-root user" "whoami" "node"
run_test "Non-root user is able to sudo" "sudo whoami" "root"