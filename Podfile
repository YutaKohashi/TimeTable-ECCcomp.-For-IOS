use_frameworks!

target 'EccStudentCom' do
pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true
pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', :submodules => true

pod 'KRProgressHUD'
pod 'PromiseKit', '~> 4.0'
pod 'Alamofire', '~> 4.0'
pod 'AsyncSwift'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end
end
