# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
target 'MyFriend' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyFriend

pod 'Kingfisher'
pod 'TTRangeSlider'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Koloda'
pod 'ObjectMapper', '~> 3.4'
pod 'CountryList'
pod 'OTPTextView'
pod 'Socket.IO-Client-Swift', '~> 12.0.0'
pod 'SwiftMessages'
pod 'Fusuma'
pod 'IQKeyboardManagerSwift'
pod 'BMPlayer', '~> 1.2.0'
pod 'GravitySliderFlowLayout'
pod 'Charts'
pod 'Google-Mobile-Ads-SDK'
pod 'iOSPhotoEditor'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
