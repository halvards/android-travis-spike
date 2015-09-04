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
  echo y | android update sdk --all --no-ui --filter platform-tool > /dev/null
  echo y | android update sdk --all --no-ui --filter tool > /dev/null

  # The BuildTools version used by your project
  echo y | android update sdk --all --no-ui --filter build-tools-23.0.0 > /dev/null

  # The SDK version used to compile your project
  echo y | android update sdk --all --no-ui --filter android-23 > /dev/null

  # Install the Extra/Android Support Library
  echo y | android update sdk --all --no-ui --filter extra-android-support > /dev/null

  # Install the Extra/Google Play Services Library
  echo y | android update sdk --all --no-ui --filter extra-google-google_play_services > /dev/null

  # Required to use Gradle or Maven to build your android project
  echo y | android update sdk --all --no-ui --filter extra-google-m2repository > /dev/null
  echo y | android update sdk --all --no-ui --filter extra-android-m2repository > /dev/null

  # API 23 (6.0.x) system images
  #echo y | android update sdk --all --no-ui --filter addon-google_apis-google-23 > /dev/null # Google APIs, use with sys-img-armeabi-v7a-addon-google_apis-google-23
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-addon-google_apis-google-23 > /dev/null # System image, requires android-23 and addon-google_apis-google-23, provides Google APIs
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-23 > /dev/null # System image, requires android-23

  # API 22 (5.1.x) system images
  #echo y | android update sdk --all --no-ui --filter android-22 > /dev/null
  #echo y | android update sdk --all --no-ui --filter addon-google_apis-google-22 > /dev/null # Google APIs, use with sys-img-armeabi-v7a-addon-google_apis-google-22
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-addon-google_apis-google-22 > /dev/null # System image, requires android-22 and addon-google_apis-google-22, provides Google APIs
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-22 > /dev/null # System image, requires android-22

  # API 21 (5.0.x) system images
  #echo y | android update sdk --all --no-ui --filter android-21 > /dev/null
  #echo y | android update sdk --all --no-ui --filter addon-google_apis-google-21 > /dev/null # Google APIs, use with sys-img-armeabi-v7a-addon-google_apis-google-21
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-addon-google_apis-google-21 > /dev/null # System image, requires android-21 and addon-google_apis-google-21, provides Google APIs
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-21 > /dev/null # System image, requires android-21

  # API 19 (4.4.x) system images
  echo y | android update sdk --all --no-ui --filter android-19 > /dev/null
  echo y | android update sdk --all --no-ui --filter addon-google_apis-google-19 > /dev/null # System image, requires android-19, provides Google APIs
  #echo y | android update sdk --all --no-ui --filter sys-img-armeabi-v7a-android-19 > /dev/null # System image, requires android-19

  touch "${INITIALIZATION_FILE}"
#fi

android list target
android delete avd --name test || true
#echo no | android create avd --force --name test --target "Google Inc.:Google APIs:23" --abi "google_apis/armeabi-v7a"
#echo no | android create avd --force --name test --target "android-23" --abi "default/armeabi-v7a"
#echo no | android create avd --force --name test --target "Google Inc.:Google APIs:22" --abi "google_apis/armeabi-v7a"
#echo no | android create avd --force --name test --target "android-22" --abi "default/armeabi-v7a"
#echo no | android create avd --force --name test --target "Google Inc.:Google APIs:21" --abi "google_apis/armeabi-v7a"
#echo no | android create avd --force --name test --target "android-21" --abi "default/armeabi-v7a"
echo no | android create avd --force --name test --target "Google Inc.:Google APIs:19" --abi "default/armeabi-v7a"
#echo no | android create avd --force --name test --target "android-19" --abi "default/armeabi-v7a"
android list avd
emulator -avd test -no-skin -no-audio -no-window &
./android-wait-for-emulator.sh
adb shell input keyevent 82
