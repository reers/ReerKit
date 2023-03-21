#
#  Be sure to run `pod spec lint ReerKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ReerKit"
  s.version      = "0.0.1"
  s.summary      = "Collections of Swift extensions and utils."

  s.description  = <<-DESC
  ReerKit contains lots of Swift extensions.
                   DESC

  s.homepage = "https://github.com/reers/ReerKit"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "phoenix" => "x.rhythm@qq.com" }

  s.ios.deployment_target = "11.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  s.swift_version = '5.3'
  s.source = { :git => "https://github.com/reers/ReerKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"

end
