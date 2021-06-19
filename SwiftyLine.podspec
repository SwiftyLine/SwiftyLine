#
# Be sure to run `pod lib lint SwiftyLine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyLine'
  s.version          = '0.1.0'
  s.summary          = 'Comman line parser for Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Define command, parsing arguments, generate help banner
                       DESC

  s.homepage         = 'https://github.com/SwiftyLine/SwiftyLine'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Magic-Unique' => '516563564@qq.com' }
  s.source           = { :git => 'https://github.com/SwiftyLine/SwiftyLine.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :osx
  s.osx.deployment_target = "10.10"

  s.swift_versions = "5.0"

  # s.resource_bundles = {
  #   'SwiftyLine' => ['SwiftyLine/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'Utils' do |ss|
      ss.source_files = 'Sources/SwiftyLine/Utils/**/*.swift'
  end
  
  s.subspec 'Operation' do |ss|
      ss.source_files = 'Sources/SwiftyLine/Operation/**/*.swift'
      ss.dependency 'SwiftyLine/Utils'
  end
  
  s.subspec 'Info' do |ss|
      ss.source_files = 'Sources/SwiftyLine/Info/**/*.swift'
      ss.dependency 'SwiftyLine/Operation'
      ss.dependency 'SwiftyLine/Utils'
  end
  
  s.subspec 'Help' do |ss|
      ss.source_files = 'Sources/SwiftyLine/Help/**/*.swift'
      ss.dependency 'SwiftyLine/Operation'
      ss.dependency 'SwiftyLine/Info'
  end
  
  s.subspec 'Parsable' do |ss|
      ss.source_files = 'Sources/SwiftyLine/Parsable/**/*.swift'
      ss.dependency 'SwiftyLine/Info'
      ss.dependency 'SwiftyLine/Utils'
      ss.dependency 'SwiftyLine/Help'
  end
  
end
