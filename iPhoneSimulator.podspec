Pod::Spec.new do |s|
  s.name = 'iPhoneSimulator'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'iPhoneSimulator for Playground allows you to display the view controller with simulating the screen size of the iPhone devices.'
  s.homepage = 'https://github.com/watanabetoshinori/iPhoneSimulator-for-Playground'
  s.author = "Watanabe Toshinori"
  s.source = { :git => 'https://github.com/watanabetoshinori/iPhoneSimulator-for-Playground.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Source/**/*.{h,swift}'
  s.resources = 'Source/**/*.{xib,storyboard}', 'Source/**/*.xcassets'

end
