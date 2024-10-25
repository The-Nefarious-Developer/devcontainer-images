ARG VARIANT=22-bookworm
FROM mcr.microsoft.com/devcontainers/typescript-node:${VARIANT}
LABEL org.opencontainers.image.source="https://github.com/The-Nefarious-Developer/devcontainer-images"

ARG CF_PATH=/home/node/.cf

# Set execution user otherwise the CF CLI directory is going to be created by root
# and auth or ownership would need to be granted with "sudo chown -R node $CF_PATH"
USER node

# Place dependencies in non-root user directory, as per documentation:
# https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# This is needed as the common CF CLI installation procedure is not configuring
# the correct path for plugins. More info at https://cli.cloudfoundry.org/en-US/v8/
ENV CF_PLUGIN_HOME=${CF_PATH}/plugins

RUN \
    # Avoid getting stuck with interactive prompts
    export DEBIAN_FRONTEND=noninteractive \
    # Install Cloud Foundry CLI
    && wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add - \
    && echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list \
    # Cache busting for CF CLI installation
    && sudo apt-get update \ 
    && sudo apt-get install cf8-cli \
    # Install Cloud Foundry Plugins
    && cf install-plugin multiapps -f \
    && cf install-plugin html5-plugin -f \
    # Install SAPUI5 CLI
    && npm install --global @ui5/cli \
    # Install CAP Tooling
    && npm install --global @sap/cds-dk \
    # Install the Cloud MTA Build Tool (MBT) 
    && npm install --global mbt \
    # Install Yeoman
    && npm install --global yo \
    # Install TypeScript
    && npm install --global typescript \
    && npm install --global ts-node \
    # Install Typescript CDS lib to avoid constantly precompiling files during development
    && npm install --global tsx