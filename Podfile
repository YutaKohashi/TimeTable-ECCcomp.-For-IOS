use_frameworks!

target 'EccStudentCom' do
pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true
pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true

pod 'FSCalendar'
pod 'Himotoki'
pod 'APIKit'
pod 'SpringIndicator'
pod 'SVProgressHUD'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end

    require 'fileutils'
    FileUtils.cp_r('/Users/yutakohashi/SourceTreeFiles/EccStudentCom/Pods/Target Support Files/Pods-EccStudentCom/Pods-EccStudentCom-acknowledgements.plist', '/Users/yutakohashi/SourceTreeFiles/EccStudentCom/EccStudentCom/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
