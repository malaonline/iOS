source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'SnapKit', '~> 0.22.0'
  pod 'DateTools'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'IQKeyboardManagerSwift'
  pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'legacy/v2'
  pod 'Google/Analytics'
  pod 'Pingpp/Alipay'
  pod 'Pingpp/Wx'
  pod 'MOBFoundation'
  pod 'ShareSDK3'
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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    case target.name
    when 'Alamofire', 'Charts', 'IQKeyboardManagerSwift', 'Kingfisher', 'SnapKit'
      target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
    end
  end
end
