# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
post_install do |installer|
    # 获取Pods项目中的目标数组(targets）然后遍历目targets
    installer.pods_project.targets.each do |target|
        # 通过目标对象（target）获取构建配置数组 (build_configurations)遍历构建配置数组
        target.build_configurations.each do |config|
            # 修改构建配置对象中的构建设置 (build_settings），将iOS 部署目标版本设为 13.0
            config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = '13.0'
        end
    end
end
source 'https://github.com/CocoaPods/Specs.git'
target 'ArtReader' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ArtReader
  pod 'SSZipArchive'
  pod 'SwiftSoup'
  target 'ArtReaderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ArtReaderUITests' do
    # Pods for testing
  end

end
