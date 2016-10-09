Pod::Spec.new do |s|
  s.name             = 'TRMosaicLayout'
  s.version          = '1.0.0'
  s.summary          = 'A mosaic collection view layout using three columns' 

  s.description      = <<-DESC
  A mosaic collection view layout using three columns. Useful for showing books, magazines, and any other types 
  of images that may follow the 8x11 format or other similar formats. Extending FMMosaicLayout and LightBox's algorithm
  to accomadate for a three column based mosaic layout. A great example of this is Snapchat's Discover Feed
                       DESC

  s.homepage         = 'https://github.com/vinnyoodles/TRMosaicLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vincent Le' => 'vinnyoodles@gmail.com' }
  s.source           = { :git => 'https://github.com/vinnyoodles/TRMosaicLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TRMosaicLayout/Classes/**/*'
end
