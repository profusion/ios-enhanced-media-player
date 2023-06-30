
Pod::Spec.new do |s|
    s.name             = 'EnhancedMediaPlayer'
    s.version          = '0.1.0'
    s.summary          = 'Simple and customizable media player for iOS'
    s.homepage         = 'https://github.com/profusion/ios-enhanced-media-player'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Profusion Sistemas e Solucoes LTDA' => '' }
    s.source           = { :git => 'https://github.com/profusion/ios-enhanced-media-player.git', :tag => s.version.to_s }
    s.ios.deployment_target = '15.0'
    s.swift_version = '5.0'
    s.source_files = 'Sources/EnhancedMediaPlayer/**/*'
  end
