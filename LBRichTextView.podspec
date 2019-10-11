Pod::Spec.new do |spec|
  spec.name         = "LBRichTextView"
  spec.version      = "0.0.2"
  spec.summary      = "支持各种自定义类型输入的强大RichTextView"
  spec.description  = "一个可以支持图片输入，视频输入，语音输入，类似于iOS系统自带的备忘录，可以定义View输入的强大富文本RichTextView。"
  spec.homepage     = "https://github.com/A1129434577/LBRichTextView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBRichTextView.git', :tag => spec.version.to_s }
  spec.source_files = "LBRichTextView/**/*.{h,m}"
  spec.requires_arc = true
end
