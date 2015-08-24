#
# Be sure to run `pod lib lint LILKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LILKit"
  s.version          = "0.0.9"
  s.summary          = "My Objective-C boilerplate junk."
  s.description      = <<-DESC
                       Objective-C stuff like:
                       * transformers 
                       *categories and 
                       * my log formatter

                       DESC
  s.homepage         = "https://github.com/gushov/LILKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "August Hovland" => "gushov@gmail.com" }
  s.source           = { :git => "https://github.com/gushov/LILKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'LILKit/**/*'
  #s.resource_bundles = {
  #  'LILKit' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CocoaLumberjack', '2.0.0'
  s.dependency 'ReactiveCocoa', '~> 2.5'
end
