Pod::Spec.new do |spec|

  spec.name         = "NCanUtils"
  spec.version      = "1.0.0"
  spec.summary      = "NCanUtils is the library for iOS written in Swift"

  spec.description  = <<-DESC
 This library helps you perform utilites about UIViewController, UINavigation, Dictionay, String,...
                   DESC

  spec.homepage     = "https://github.com/nguyencan/NCanUtils"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Nguyen Can" => "cannc.92tf@gmail.com" }

  spec.ios.deployment_target = "10.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/nguyencan/NCanUtils.git", :tag => "#{spec.version}" }
  spec.source_files  = "NCanUtils/**/*.{h,m,swift,xcassets,storyboard}"
  # spec.resource_bundles = {
  # 	'NCanUtilsBundle' => ['NCanUtils/*/Assets.xcassets']
  # }

end
