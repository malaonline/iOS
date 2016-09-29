# #!/bin/sh
# if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
#   echo "This is a pull request. No deployment will be done."
#   exit 0
# fi
# if [[ "$TRAVIS_BRANCH" != "master" ]]; then
#   echo "Testing on a branch other than master. No deployment will be done."
#   exit 0
# fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Debug-iphoneos"

xcodebuild -exportArchive -archivePath $BUILD_PATH -exportPath $IPA_PATH -exportOptionsPlist exportOptions.plist

if [ ! -z "$FIR_APP_TOKEN" ]; then
  echo "***************************"
  echo "*   Uploading to Fir.im   *"
  echo "***************************"
  fir p $IPA_PATH/$APP_NAME.ipa -T $FIR_APP_TOKEN
fi
