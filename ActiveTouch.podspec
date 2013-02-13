Pod::Spec.new do |s|
  s.name         = "ActiveTouch"
  s.version      = "1.0.0"
  s.summary      = "ActiveRecord implementation for iOS using TouchDB."
  s.homepage     = "https://github.com/lucasmedeirosleite/ActiveTouch"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author       = { "Lucas Medeiros" => "lucastoc@gmail.com" }
  
  s.source       = { :git => "https://github.com/lucasmedeirosleite/ActiveTouch.git", :tag => "1.0.0" }
  
  s.requires_arc = true

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.source_files = FileList['ActiveTouchExample/ActiveTouch/**/**/*.{h,m}']
  
  s.dependency 'CouchCocoa', '~> 1.0'
  s.dependency 'TouchDB', '~> 1.0'
  s.dependency 'Mantle', '~> 0.2.2'
  s.dependency 'Kiwi', '~> 2.0.4'
  
end
