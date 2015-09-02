#!/bin/bash

# Source: https://docs.snap-ci.com/the-ci-environment/languages/android/

# Raise an error if any command fails
set -e

# Existence of this file indicates that all dependencies were previously installed, and any changes to this file will use a different filename
INITIALIZATION_FILE="$ANDROID_HOME/.initialized-dependencies-$(git log -n 1 --format=%h -- $0)"

#if [ ! -e "${INITIALIZATION_FILE}" ]; then
  # Fetch and initialize $ANDROID_HOME
  download-android

  cat $(which download-android)

  # List available SDK components
  android list sdk --all --no-ui --extended

  # Use the latest Android SDK tools
  echo y | android --silent update sdk --all --no-ui --filter platform-tool
  echo y | android --silent update sdk --all --no-ui --filter tool

  # The BuildTools version used by your project
  echo y | android --silent update sdk --all --no-ui --filter build-tools-23.0.0

  # The SDK version used to compile your project
  echo y | android --silent update sdk --all --no-ui --filter android-23

  # Install the Extra/Android Support Library
  echo y | android --silent update sdk --all --no-ui --filter extra-android-support

  # Install the Extra/Google Play Services Library
  echo y | android --silent update sdk --all --no-ui --filter extra-google-google_play_services

  # Required to use Gradle or Maven to build your android project
  echo y | android --silent update sdk --all --no-ui --filter extra-google-m2repository
  echo y | android --silent update sdk --all --no-ui --filter extra-android-m2repository

  # Specify at least one system image to run emulator tests
  #echo y | android --silent update sdk --all --no-ui --filter addon-google_apis-google-23
  #echo y | android --silent update sdk --all --no-ui --filter sys-img-armeabi-v7a-addon-google_apis-google-23 # requires android-23 and addon-google_apis-google-23, includes Google APIs
  echo y | android --silent update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-23 # requires android-23
  #echo y | android --silent update sdk --all --no-ui --filter android-19
  #echo y | android --silent update sdk --all --no-ui --filter addon-google_apis-google-19 # requires android-19, includes Google APIs
  #echo y | android --silent update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-19 # requires android-19

  touch "${INITIALIZATION_FILE}"
#fi

android list target
#echo no | android create avd --force --name test --target "Google Inc.:Google APIs:23" --abi "google_apis/armeabi-v7a"
echo no | android create avd --force --name test --target "android-23" --abi "default/armeabi-v7a"
#echo no | android create avd --force --name test --target "Google Inc.:Google APIs:19" --abi "default/armeabi-v7a"
#echo no | android create avd --force --name test --target "android-19" --abi "default/armeabi-v7a"
emulator -avd test -no-skin -no-audio -no-window &
./android-wait-for-emulator.sh
adb shell input keyevent 82 &
