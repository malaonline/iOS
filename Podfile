source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'SnapKit', '~> 3.0.2'
  pod 'DateTools'
  pod 'Alamofire', '~> 4.0.1'
  pod 'Kingfisher'
  pod 'IQKeyboardManager', :git => 'https://github.com/hackiftekhar/IQKeyboardManager.git', :branch => 'swift3'
  pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'Chart2.2.5-Swift3.0'
  pod 'Google/Analytics'
  pod 'Pingpp/Alipay'
  pod 'Pingpp/Wx'
  pod 'MOBFoundation'
  pod 'ShareSDK3'
  pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
  pod 'PagingMenuController', :git => 'https://github.com/kitasuke/PagingMenuController.git', :branch => 'swift3.0'
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
