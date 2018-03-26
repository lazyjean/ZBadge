# coding: utf-8
Pod::Spec.new do |s|
  s.name             = 'ZBadge'
  s.version          = '2.0.0'
  s.summary          = '小红点组件'
  s.description      = <<-DESC
    实现小红点功能的组件,完全支持storyboard
                       DESC

  s.homepage         = 'https://github.com/lazyjean/ZBadge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuzhen' => 'lazyjean@foxmail.com' }
  s.source           = { :git => 'https://github.com/lazyjean/ZBadge.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ZBadge/*.swift'
  s.frameworks = 'UIKit'
end
