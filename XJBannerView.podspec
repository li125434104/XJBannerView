#
#  Be sure to run `pod spec lint XJBannerView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "XJBannerView"
  s.version      = "0.0.1"
  s.summary      = "A bannerView."
  s.description  = <<-DESC
                      A circle BannerView.
                   DESC
  s.homepage     = "https://github.com/li125434104/XJBannerView"
  s.license      = "MIT"
  s.author       = { "li125434104" => "125434104@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/li125434104/XJBannerView.git", :tag => "0.0.1" }
  s.source_files  = "XJBannerView", "XJBannerView/**/*.{h,m}"
  s.framework  = "UIKit"

  
end
