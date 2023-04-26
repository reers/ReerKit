#
#  Be sure to run `pod spec lint ReerKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ReerKit"
  s.version      = "0.0.2"
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

  s.swift_version = '5.5'
  s.source = { :git => "https://github.com/reers/ReerKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"

  s.subspec 'General' do |ss|
    ss.source_files  = 'Sources/General/*.swift'
  end

  # StandardLibrary Extensions
  s.subspec 'StandardLibrary' do |ss|
    ss.source_files  = 'Sources/StandardLibrary/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # Foundation Extensions
  s.subspec 'Foundation' do |ss|
    ss.source_files  = 'Sources/Shared/*.swift', 'Sources/Foundation/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # UIKit Extensions
  s.subspec 'UIKit' do |ss|
    ss.source_files  = 'Sources/Shared/*.swift', 'Sources/UIKit/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # Utility
  s.subspec 'Utility' do |ss|
    ss.source_files  = 'Sources/Utility/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # CoreGraphics Extensions
  s.subspec 'CoreGraphics' do |ss|
    ss.source_files  = 'Sources/CoreGraphics/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # CoreLocation Extensions
  s.subspec 'CoreLocation' do |ss|
    ss.source_files  = 'Sources/CoreLocation/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # CoreAnimation Extensions
  s.subspec 'CoreAnimation' do |ss|
    ss.source_files  = 'Sources/Shared/*.swift', 'Sources/CoreAnimation/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # CryptoKit Extensions
  s.subspec 'CryptoKit' do |ss|
    ss.source_files  = 'Sources/Shared/*.swift', 'Sources/CryptoKit/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # MapKit Extensions
  s.subspec 'MapKit' do |ss|
    ss.source_files = 'Sources/Shared/*.swift', 'Sources/MapKit/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # Dispatch Extensions
  s.subspec 'Dispatch' do |ss|
    ss.source_files = 'Sources/Dispatch/*.swift'
    ss.dependency 'ReerKit/General'
  end

  # WebKit Extensions
  s.subspec 'WebKit' do |ss|
    ss.source_files = 'Sources/WebKit/*.swift'
  end

end
