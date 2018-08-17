
Pod::Spec.new do |s|
  s.name             = 'LYSegmentViewController'
  s.version          = '1.0.1'
  s.summary          = '一个快速继承UITableView嵌套滑动的控件'
  s.homepage         = 'https://github.com/wans3112/LYSegmentViewController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wans3112' => 'wanslm@foxmail.com' }
  s.source           = { :git => 'https://github.com/wans3112/LYSegmentViewController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'LYSegmentViewController/Classes/**/*'

  # s.resource_bundles = {
  #   'LYSegmentViewController' => ['LYSegmentViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Masonry'

  s.prefix_header_contents = "#import <LYSegmentViewController/LYSegment.h>", "#import <Masonry/Masonry.h>"

end
