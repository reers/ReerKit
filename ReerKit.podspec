#
#  Be sure to run `pod spec lint ReerKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ReerKit"
  s.version      = "1.0.24"
  s.summary      = "Collections of Swift extensions and utils."

  s.description  = <<-DESC
  ReerKit contains lots of Swift extensions.
                   DESC

  s.homepage = "https://github.com/reers/ReerKit"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "phoenix" => "x.rhythm@qq.com" }

  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "4.0"
  s.tvos.deployment_target = "12.0"
  s.visionos.deployment_target = "1.0"

  s.swift_version = '5.9'
  s.source = { :git => "https://github.com/reers/ReerKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"

end
