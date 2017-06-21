
Pod::Spec.new do |s|
s.name         = "KYTabBarController"
s.summary      = "KYTabBarController this is a high extension, simple completion of the mainstream App framework for IOS"
s.description  = "This is iPad and iPhone compatible. Supports landscape and portrait orientations and can be used inside UINavigationController."
s.version      = '0.0.4'
s.homepage     = "https://github.com/kingly09/KYTabBarController"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "kingly" => "libintm@163.com" }
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/kingly09/KYTabBarController.git", :tag => s.version.to_s }
s.social_media_url   = "https://github.com/kingly09"
s.source_files = 'libs/*.{h,m}'
s.framework    = "UIKit"
s.requires_arc = true
end
