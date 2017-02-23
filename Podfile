source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'SnapKit', '~> 3.0.2'
  pod 'DateToolsSwift'
  pod 'Alamofire', '~> 4.0.1'
  pod 'Kingfisher', '~> 3.1.0'
  pod 'IQKeyboardManagerSwift', '~> 4.0.8'
  pod 'Charts', '~> 3.0.1'
  pod 'Google/Analytics'
  
  pod 'Pingpp/Alipay'
  pod 'Pingpp/Wx'
  
  pod 'ShareSDK3'
  pod 'MOBFoundation'
  pod 'ShareSDK3/ShareSDKUI'
  pod 'ShareSDK3/ShareSDKExtension'
  pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
  
  # pod 'PagingMenuController'
  pod 'KSCrash', '~> 1.8.13'
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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    case target.name
      when 'Alamofire', 'Charts', 'IQKeyboardManager', 'Kingfisher', 'SnapKit','PagingMenuController'
        target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
