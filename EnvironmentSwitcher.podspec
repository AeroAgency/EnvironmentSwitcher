Pod::Spec.new do |s|
    s.ios.deployment_target = '10.0'
  	s.version = '1.1.1'
    s.name = 'EnvironmentSwitcher'
    s.summary = 'Switch REST environments on the fly.'
    s.description = 'Switch servers and HTTP endpoints on the fly and before starting the application.'
    
  	s.swift_versions = ['5.0']
  	s.cocoapods_version = '>= 1.7.0'  
    
  	s.license = { :type => 'MIT', :file => 'LICENSE.md' }
    s.authors = { 'Stas Telnov' => 'telnov@aeroidea.ru' }
    s.homepage = 'https://github.com/AeroAgency/EnvironmentSwitcher'
    
    s.source = { :git => "https://github.com/AeroAgency/EnvironmentSwitcher.git", :tag => s.version }
    s.source_files = 'Source/**/*.swift'
    s.resources = "Source/**/*.{xcassets,xib}"
end
