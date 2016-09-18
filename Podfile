source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def pods
    pod 'SnapKit', '~> 0.30.0.beta2'
    pod 'DateTools', '~> 1.7.0'
    pod 'Alamofire', '~> 3.5.0'
    pod 'Kingfisher', '~> 2.5.1'
    pod 'IQKeyboardManagerSwift', '~> 4.0.5'
    pod 'Charts', '~> 2.2.5'
    pod 'Google/Analytics', '~> 3.0.3'
    pod 'Pingpp/Alipay', '~> 2.2.8'
    pod 'Pingpp/Wx', '~> 2.2.8'
    pod 'MOBFoundation', '~> 2.0.11'
    pod 'ShareSDK3', '~> 3.4.1'
    pod 'ShareSDK3/ShareSDKUI', '~> 3.4.1'
    pod 'ShareSDK3/ShareSDKPlatforms/WeChat', '~> 3.4.1'
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
