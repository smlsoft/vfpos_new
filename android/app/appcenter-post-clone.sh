#!/usr/bin/env bash
# place this script in project/android/app/
cd ..
# fail if any command fails
set -e
# debug log
set -x

cd ..

git clone -b stable https://github.com/flutter/flutter.git
export PATH=`pwd`/flutter/bin:$PATH

flutter channel stable
flutter doctor


echo "Installed flutter to `pwd`/flutter"

flutter pub get
# flutter build apk --release

# # copy the APK where AppCenter will find it
# mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_

flutter build apk --flavor vfpos -t lib/main_vfpos.dart --release --dart-define=ENVIRONMENT=STAGING

# copy the APK where AppCenter will find it
mkdir -p android/app/build/outputs/apk/; mv build/app/outputs/apk/release/app-release.apk $_

# copy the AAB where AppCenter will find it
#mkdir -p android/app/build/outputs/bundle/; mv build/app/outputs/bundle/release/app-release.aab $_