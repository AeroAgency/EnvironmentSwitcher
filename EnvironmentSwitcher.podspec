Pod::Spec.new do |s|
    s.ios.deployment_target = '10.0'
    s.name = 'EnvironmentSwitcher'
    s.authors = 'Stas Telnov'
    s.summary = 'Переключатель окружения'
    s.version = '1.0'
    s.homepage = 'https://aeroidea.ru/'
    s.source = { :path => 'source/' }
    s.source_files = 'source/**/*.swift'
    s.resources = "source/**/*.{xcassets,xib}"
    
    s.exclude_files = 'source/**/*Tests.*'

#     s.weak_framework = "XCTest"
#     s.pod_target_xcconfig = {
#       'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"',
#     }
end
