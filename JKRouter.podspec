#
# Be sure to run `pod lib lint JKRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JKRouter'
  s.version          = '0.2.6.4'
  s.summary          = 'this is a tool to help you to handle the push or pop between Viewcontrollers with your specified URL.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: this is a tool to help you to handle the push or pop between Viewcontrollers with your specified URL
                       DESC

  s.homepage         = 'https://github.com/xindizhiyin2014/JKRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HHL110120' => '929097264@qq.com' }
  s.source           = { :git => 'https://github.com/xindizhiyin2014/JKRouter.git', :tag => s.version.to_s }
  s.social_media_url = 'http://blog.csdn.net/hanhailong18?viewmode=contents'

  s.ios.deployment_target = '7.0'

  s.source_files = 'JKRouter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JKRouter' => ['JKRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'JKDataHelper'
end
