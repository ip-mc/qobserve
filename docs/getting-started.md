# Getting Started

## Configuration File
- Copy `src/config.example` to `src/config.json`
- Edit `src/config.json` to fit your specific needs
- Read the [config documentation](config.md) to understand the format
## Generate Secrets
- Most observability platforms require an API key which should not be shared or stored in plain text. This module expects any secrets to be encrypted with AES-256-CBC and base64 encoded.
- Find the observability service you are using in [supported services](services/supported-services.md) to learn what secrets are needed for your use case.
- Read the [secrets documentation](secrets.md) on how to generate and store secrets and keys.

## Load the Module
### Manually
- Log into the cores web ui
- Navigate to `Files`
- Create a folder called `qobserve`
- upload the contents of `src` in this repo to the newly created `qobserve` folder

### Using the script
- Use the provided [script](../scripts/push-module.py) to load the module to all your cores
## Load the User Component
- A user component `qobserve-x.x.x.quc` is provided with the necessary components to load into your design
- This user component contains:
	- secret storage plugin
		- holds the [encryption key and iv](secrets.md) used to decrypt secrets
	- qobserve script
		- loads the module and starts logging
	- HA/Refresh script
		- copies the module from the media folder on the core to the design's lua folder and restarts qobserve every minute
		- restarts qobserve if an error occurs
		- provides a toggle button to start or stop logging

## Activate
- In QSYS-Designer activate the Log toggle button to start logging to your server