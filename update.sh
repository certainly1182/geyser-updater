#!/bin/bash
# Author: @certainly1182
# Description: Checks for updates to Geyser and downloads them if available
dependencies=(curl unzip tmux)
# The name of the local Geyser jar
localJar='Geyser-Standalone.jar'
# Name of the tmux session where Geyser is running
tmuxSession='geyser'
# Latest successful build URLs
buildURL="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/"
jarURL="$buildURL/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar"
buildNumberURL="$buildURL/buildNumber"

checkDependencies() {
    for command in "${dependencies[@]}"; do
        if ! command -v "$command" &> /dev/null; then
            echo "$command is not installed, please install it before running this script."
            exit 1
        fi
    done
}

checkForUpdates() {
    # Get the local build number
    local localBuild
    localBuild=$(unzip -p "$localJar" git.properties | grep "git.build.number" | cut -c 18-)
    # Get the latest build number
    latestBuild=$(curl -s "$buildNumberURL")
    
    if ! [[ $latestBuild =~ ^[0-9]+$ ]]; then
    echo "Failed to get latest build number"
    exit 1
    fi
    
    if [[ $localBuild -eq $latestBuild ]]; then
    echo "No update available, you have the latest build ($latestBuild)"
    exit 0
    else
    echo "Update available, from $localBuild to $latestBuild"
    fi
}

confirmUpdate() {
    while true; do
        read -p "Do you wish to update? [y/n] " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

archiveOld() {
    echo "Archiving old version(s)..."
    # Remove the old old version
    for file in $localJar.old; do
        rm "$file"
    done

    # Rename the old version
    for file in $localJar; do
        mv "$file" "$file.old"
    done
}

downloadGeyser() {
    # Download the latest version
    curl --progress "$jarURL" -o $localJar
    if [ $? -ne 0 ]; then
        echo "Failed to download Geyser"
        exit 1
    fi
}

stopGeyser() {
    echo "Stopping Geyser tmux session: $tmuxSession..."
    tmux kill-session -t $tmuxSession
}

startGeyser() {
    echo "Starting Geyser in a tmux session: $tmuxSession..."
    tmux new-session -d -s $tmuxSession 'sh start.sh'
}

checkDependencies
checkForUpdates
confirmUpdate
stopGeyser
archiveOld
downloadGeyser
startGeyser