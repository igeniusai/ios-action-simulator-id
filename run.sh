#!/bin/bash

# Script to get the first matching device id based on the specified device model and ios version available in the current machine.
# usage example: ./simulatorId.sh "iPhone 15" "17.0.2"

DEVICE=$1
OS_VERSION=$2

CORE_SIMULATOR_OS_PREFIX="com.apple.CoreSimulator.SimRuntime.iOS-"

if [ -z "$DEVICE" ]
then
      echo "script called without arguments to specify a device and ios version (ex: \"iPhone 15\" \"17.0.2\")"
      exit 1
fi

SIM_RUNTIME="$CORE_SIMULATOR_OS_PREFIX$(echo "$OS_VERSION" | sed 's/\./-/g')"

SIMULATOR_ID=$(xcrun simctl list devices --json | jq -r ".devices.\"$SIM_RUNTIME\".[] | select(.name == \"$DEVICE\")".udid)

if [ -z "$SIMULATOR_ID" ]
then
      echo "No simulator found for $DEVICE ($OS_VERSION), here the list of available devices:"
      xcrun simctl list devices
      exit 1
fi

echo "simulator id found: $SIMULATOR_ID"

echo "simulatorid=$SIMULATOR_ID" >> $GITHUB_OUTPUT