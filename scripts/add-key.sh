#!/bin/sh
echo "***************************"
echo "*     Security Import     *"
echo "***************************"
security list-keychain
security import ./scripts/certs/apple.cer -k ~/Library/Keychains/login.keychain -T /usr/bin/codesign
security import ./scripts/certs/dist.cer -k ~/Library/Keychains/login.keychain -T /usr/bin/codesign
security import ./scripts/certs/dist.p12 -k ~/Library/Keychains/login.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
# mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
# cp ./scripts/profile/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
