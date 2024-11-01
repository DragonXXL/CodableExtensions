# 指定源
source 'https://github.com/CocoaPods/Specs.git'

# 忽略所有pod警告
inhibit_all_warnings!

platform :ios, '13.0'

target 'CodableExtensions' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CodableExtensions
  pod 'CodableExtensions', :path => './'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        excluded_archs = config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]']
        excluded_archs = excluded_archs.nil? ? '' : excluded_archs
        if !excluded_archs.include?('arm64')
          excluded_archs = "#{excluded_archs} arm64"
        end
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = excluded_archs
      end
    end
  end
end
