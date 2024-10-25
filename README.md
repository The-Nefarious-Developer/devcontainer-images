# Nefarious Development Container Images

[![Build, Test and Deploy](https://github.com/The-Nefarious-Developer/devcontainer-images/actions/workflows/pipeline.yaml/badge.svg)](https://github.com/The-Nefarious-Developer/devcontainer-images/actions/workflows/pipeline.yaml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

A set of development container images that can be used for SAP BTP development with Cloud Application Programming Model projects in Visual Studio Code.

> These images were created to provide a consistent set of dependencies to the development container templates provided through [this repository](https://github.com/The-Nefarious-Developer/devcontainer-templates).

If you have any question, suggestion or request regarding what this repository can offer, you can use this [discussion area](https://github.com/orgs/The-Nefarious-Developer/discussions).

## Content

- [`scripts`](scripts) - Contains a set of scripts to build the project.
- [`src`](src) - Contains reusable dev container images.
- [`test`](test) - Contains the test suite for each provided image.

## Available Images

Ths repository generates the following docker/devcontainer images using GHCR:

| Image                     | Base Image                                                                                                            | Variants                                                          |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| sap-cap-javascript-node   | [mcr.microsoft.com/devcontainers/javascript-node](https://hub.docker.com/r/microsoft/devcontainers-javascript-node)   | [Versions Available](./src/sap-cap-javascript-node/variants.json) |
| sap-cap-typescript-node   | [mcr.microsoft.com/devcontainers/typescript-node](https://hub.docker.com/r/microsoft/devcontainers-typescript-node)   | [Versions Available](./src/sap-cap-typescript-node/variants.json) |

## How it works

The directories inside the [`src`](src) folder will contain the files that will compose the images to be created. 

Each image folder will have the following structure:
- **.devcontainer** which is going to contain the `Dockerfile` and the `devcontainer.json` with properties and dependencies for the container image creation. 
- **variants.json** with versions that will be set to the upstream image of that devcontainer.

Here is an example of `variants.json` file:

```json
{
    "variants": [
        "version1",
        "version2"
    ]
}
```

The usage of this file is is directly tied to the *variant* argument provided to the `devcontainer.json` and its values will be related to the image directories to generate a `variants-matrix.json` file during the **build** process.

This procedure will enable a GitHub Actions pipeline automation to read all images that needs to be deployed through a matrix strategy configured in the `setup` job.

## Testing

Each image needs to have a test implementation. The GitHub Actions pipeline will search for those images based on the `variant-matrix.json` created through the build script.

> **Note:** The lack of test implementation might cause the CI/CD pipeline to fail.

The test implementation is using functions available through the usage of the [`harness.sh`](test/test-utils/harness.sh) file. <br />
Each image should call the `setup` function to properly configure the test environment. This process will generate a temporary docker image to be executed at the evaluation process.

Template for test implementation:

```bash
#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../test-utils/harness.sh"

setup "<image>" "$VARIANT"

run_test "<test description>" "<evaluation command>" "<expected value>"
...
```

### Testing locally

To test the images locally, the environment variable `VARIANT` need to be set prior to the bash file execution.

Template for command to run the test locally:

```
VARIANT=<upstream version> test/<image>/test.sh
```

The [`package.json`](package.json) file contains an example of local testing through the script `test:local`.

## How can I contribute?

Contributions are welcome! Here's how you can get involved:

1. **Report Issues:** Found a bug or have a feature request? [Open an issue](https://github.com/The-Nefarious-Developer/devcontainer-images/issues). <br />
2. **Submit Pull Requests:** Fork the repository, create a new branch, make your changes, and submit a PR. <br />
3. **Improve Documentation:** Help us improve the README or add examples to make setup easier. <br />
4. **Test & Feedback:** Try the devcontainer images and give us feedback to improve them.

Please follow the [contribution guidelines](CONTRIBUTING.md) for more details.

## References

These images were created following the guidelines provided through the [devcontainers/template-starter](https://github.com/devcontainers/template-starter) and [devcontainers/images](https://github.com/devcontainers/images).

## Acknowledgments

Special thanks to [Christian Sutter](https://github.com/csutter) who came up with the [harness](https://en.wikipedia.org/wiki/Test_harness) test strategy used in this project.

## License
Copyright (c) 2024 The Nefarious Developer <br />
Licensed under the MIT License. See [LICENSE](LICENSE).