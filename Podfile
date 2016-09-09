source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def pods
    pod 'SnapKit'
    pod 'DateTools'
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'IQKeyboardManagerSwift'
    pod 'Charts'
    pod 'Google/Analytics'
    pod 'Pingpp/Alipay'
    pod 'Pingpp/Wx'
    pod 'MOBFoundation'
    pod 'ShareSDK3'
    pod 'ShareSDK3/ShareSDKUI'
    pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
end

target 'parent-dev' do
  pods

  target 'parentTests' do
    inherit! :search_paths
  end
end

target 'parent-stage' do
  pods
end

target 'parent-prd' do
  pods
end
