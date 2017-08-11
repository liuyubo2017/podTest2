Pod::Spec.new do |s|
s.name = ‘podTest2’
s.version = ‘1.0.0’
s.license = 'MIT'
s.description  = <<-DESC 
                          podTest2 是一个用于保存一些常用工具类的工具
                   DESC
s.summary = 'A Text in iOS.'
s.homepage = 'https://github.com/liuyubo2017/podTest2.git'
s.authors = { ‘liuyubo’ => ’3065719588@qq.com' }
s.source = { :git => "https://github.com/liuyubo2017/podTest2.git", :tag => “1.0.0”}
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = "podTest2", "*.{h,m}"
end
