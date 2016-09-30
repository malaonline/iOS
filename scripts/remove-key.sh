#!/bin/sh
echo "***************************"
echo "*     Security Delete     *"
echo "***************************"
security delete-keychain login.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_NAME.mobileprovision
