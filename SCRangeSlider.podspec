
Pod::Spec.new do |spec|

  spec.name         = "SCRangeSlider"
  spec.version      = "0.0.4"
  spec.summary      = "Range slider for iOS."
  spec.description  = <<-DESC
  An easy to use range slider.
                   DESC

  spec.homepage     = "https://github.com/SmileCicy/RangeSlider"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "SmileCicy" => "592751156@qq.com" }

  spec.platform     = :ios, "9.0"
  spec.ios.deployment_target = "9.0"
  spec.swift_version = '5.3'

  spec.source       = { :git => "https://github.com/SmileCicy/RangeSlider.git", :tag => "#{spec.version}" }

  spec.source_files  = "RangeSlider/RangeSlider/**/*.swift"
  spec.resource_bundles = {
    'RangeSlider' => ['RangeSlider/Image.xcassets']
  }  

end
