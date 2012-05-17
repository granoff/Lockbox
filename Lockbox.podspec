Pod::Spec.new do |s|
  s.name     = 'Lockbox'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Lockbox is an Objective-C utility class for storing data securely in the keychain. Use it to store small, sensitive bits of data securely.'
  s.homepage = 'https://github.com/granoff/Lockbox'
  s.author   = 'Mark Granoff'

  s.source   = { :git => 'https://github.com/granoff/Lockbox.git', :commit => '6e910cb8c5' } # :tag => '0.0.1'

  s.source_files = 'Lockbox.{h,m}'
  s.clean_path = 'LockBox'
  s.framework = 'Security'
end
