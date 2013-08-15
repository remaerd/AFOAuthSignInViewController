@version = "1.0.0"

Pod::Spec.new do |s|
  s.name         = "AFOAuthSignInViewController"
  s.version      = @version
  s.summary      = "OAuth1 / OAuth2 Web Service Authenication View Controller within the App."
  s.homepage     = "https://github.com/remaerd/AFOAuthSignInViewController"
  s.license      = { :type => 'MIT'}

  s.author       = { "Sean Cheng" => "sean@extremelylimited.com" }
  s.source       = { :git => "https://github.com/remaerd/AFOAuthSignInViewController.git", :tag => @version }
  
  s.source_files = 'AFOAuthSignInViewController/**/*.{h,m}'

  s.dependency 'AFOAuth1Client'
  s.dependency 'AFOAuth2Client'

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
end
