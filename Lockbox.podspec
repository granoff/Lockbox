Pod::Spec.new do |s|
  s.name     = 'Lockbox'
  s.version  = '3.0.7'
  s.license  = 'MIT'
  s.summary  = 'Lockbox is an Objective-C utility class for storing data securely in the keychain. Use it to store small, sensitive bits of data securely.'
  s.homepage = 'https://github.com/granoff/Lockbox'
  s.author   = 'Mark H. Granoff'

  s.source   = { :git => 'https://github.com/granoff/Lockbox.git', :tag => s.version }

  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Lockbox.{h,m}'
  s.frameworks = 'Security'
  s.requires_arc = true
end
