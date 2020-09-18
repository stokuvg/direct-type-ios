Pod::Spec.new do |s|
  s.name = 'TudVerCheck'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.version = '0.20.9.15'
  s.source = { :git => 'git@github.com:swagger-api/swagger-mustache.git', :tag => 'v1.0.0' }
  s.authors = 'Swagger Codegen'
  s.license = 'Proprietary'
  s.homepage = 'http://tud-swagger-ui.s3-website-ap-northeast-1.amazonaws.com'
  s.summary = 'アップデート確認API'
  s.source_files = 'TudVerCheck/Classes/**/*.swift'
  s.dependency 'PromiseKit', '~> 6.8'
  s.dependency 'Alamofire', '~> 4.9.0'
end
