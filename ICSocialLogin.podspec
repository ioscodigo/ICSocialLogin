Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = 'ICSocialLogin'
  s.summary = 'Wrap login method on each famous social media'
  s.requires_arc = true
  s.version = '1.0.0.beta-1'
  s.license = { :type => "MIT", :file => 'LICENSE' }
  s.author = { 'Digital Khrisna' => 'digital.khrisna@gmail.com' }
  s.homepage = 'https://github.com/ioscodigo/ICSocialLogin'
  s.source = { :git => 'https://github.com/ioscodigo/ICSocialLogin.git', :tag => s.version}
  
  s.subspec 'Core' do |core|
    core.source_files = 'ICSocialLogin/ExternalLoginInterface.swift'
  end

  s.subspec 'Facebook' do |subspec|
    subspec.dependency 'ImageSlideshow/Core'
    subspec.dependency 'FacebookCore', '~> 0.2.0'
    subspec.dependency 'FacebookLogin', '~> 0.2.0'
    subspec.source_files = 'ImageSlideshow/Core/ExternalLoginFacebook.swift'
  end

  s.subspec 'Twitter' do |subspec|
    subspec.dependency 'ImageSlideshow/Core'
    subspec.dependency 'FacebookCore', '~> 0.2.0'
    subspec.dependency 'FacebookLogin', '~> 0.2.0'
    subspec.source_files = 'ImageSlideshow/Core/ExternalLoginTwitter.swift'
  end

  s.subspec 'Socialite' do |subspec|
    subspec.dependency 'ImageSlideshow/Core'
    subspec.source_files = 'ImageSlideshow/Core/ExternalLogin.swift'
  end

  s.default_subspec = 'Core'
end