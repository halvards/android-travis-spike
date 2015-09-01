#!/bin/bash

# Source: https://docs.snap-ci.com/the-ci-environment/languages/android/

# Raise an error if any command fails
set -e

# Existence of this file indicates that all dependencies were previously installed, and any changes to this file will use a different filename
INITIALIZATION_FILE="$ANDROID_HOME/.initialized-dependencies-$(git log -n 1 --format=%h -- $0)"

if [ ! -e "${INITIALIZATION_FILE}" ]; then
  # Fetch and initialize $ANDROID_HOME
  download-android

  # Use the latest Android SDK tools
  echo y | android update sdk --no-ui --filter platform-tool > /dev/null
  echo y | android update sdk --no-ui --filter tool > /dev/null

  # The BuildTools version used by your project
  echo y | android update sdk --no-ui --filter build-tools-22.0.1 --all > /dev/null

  # The SDK version used to compile your project
  echo y | android update sdk --no-ui --filter android-22 > /dev/null

  # Install the Extra/Android Support Library
  echo y | android update sdk --no-ui --filter extra-android-support --all > /dev/null

  # Install the Extra/Google Play Services Library
  echo y | android update sdk --no-ui --filter extra-google-google_play_services --all > /dev/null

  # Required to use Gradle or Maven to build your android project
  echo y | android update sdk --no-ui --filter extra-google-m2repository --all > /dev/null
  echo y | android update sdk --no-ui --filter extra-android-m2repository --all > /dev/null

  # Specify at least one system image to run emulator tests
  echo y | android update sdk --no-ui --filter sys-img-armeabi-v7a-addon-google_apis-google-22 --all > /dev/null

  touch "${INITIALIZATION_FILE}"
fi

android list target
echo no | android create avd --force --name test --target "Google Inc.:Google APIs:22" --abi "google_apis/armeabi-v7a"
emulator -avd test -no-skin -no-audio -no-window &
./android-wait-for-emulator.sh
adb shell input keyevent 82 &

echo Starting Gradle build
./gradlew --no-daemon clean build connectedCheck

