platform :ios, '13.0'
use_frameworks!

target 'PokerCaculator' do
  # 基础网络
  pod 'Alamofire'
  # 图片
  pod 'Kingfisher'
  # JSON
  pod 'HandyJSON'
  # 响应式编程
  pod 'RxSwift'
  # 格式化
  pod 'SwiftLint'
  # 设备识别
  pod 'DeviceKit'
  # Log日志
  pod 'SwiftyBeaver'
  # 网络程序库
  pod 'Moya'
  # 布局
  pod 'SnapKit'
  # HUD
  pod 'ProgressHUD'
  # toast
  pod 'Toast-Swift'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
   config.build_settings['CODE_SIGNING_ALLOWED'] ="NO"
  end
 end
end