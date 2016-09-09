inhibit_all_warnings!
# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!
inhibit_all_warnings!
workspace 'mala-ios'

pod 'SnapKit', '~> 0.22.0'
pod 'DateTools', '~> 1.7.0'
pod 'Alamofire', '~> 3.3.1'
pod 'Kingfisher', '~> 2.2.2'
pod 'IQKeyboardManagerSwift', '~> 4.0.5'
pod 'Charts', '~> 2.2.5'
pod 'Google/Analytics', '~> 3.0.3'

# Ping++
pod 'Pingpp/Alipay', '~> 2.2.8'
pod 'Pingpp/Wx', '~> 2.2.8'

# ShareSDK
pod 'MOBFoundation', '~> 2.0.11'
pod 'ShareSDK3', '~> 3.4.1'
pod 'ShareSDK3/ShareSDKUI', '~> 3.4.1'
pod 'ShareSDK3/ShareSDKPlatforms/WeChat', '~> 3.4.1'



target 'parent-dev' do
  target 'parentTests' do
    inherit! :search_paths
  end
end

target 'parent-stage' do
end

target 'parent-prd' do
end
