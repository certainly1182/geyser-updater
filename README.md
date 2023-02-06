# Geyser Updater Script
This script checks for updates to the [Geyser](https://geysermc.org) standalone jar and downloads it if available.

## Prerequisites
- curl
- unzip
- tmux
## Usage
1. Download the `update.sh` file.
2. Make it executable using `chmod +x update.sh`.
3. Run the script using `./update.sh`.
## Description
The script first determines the local Geyser build number by unzipping the local jar and extracting the `git.build.number` property.

It then fetches the latest build number from the Geyser Jenkins CI server and compares it with the local build number. If an update is available, the script will prompt the user if they want to update. If the user chooses to update, the current jar will be saved as `Geyser-Standalone.jar.old` and the latest jar will be downloaded.

## Note
The script assumes that the local jar file is named `Geyser-Standalone.jar`. If the jar file has a different name, the script should be modified accordingly.
