Pod::Spec.new do |s|
  s.name              = "OCFuntime"
  s.version           = "0.3.1-beta1"
  s.summary           = "OCFuntime is a toolkit for objective-c runtime."
  s.homepage          = "https://github.com/belkevich/ocfuntime"
  s.license           = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.social_media_url  = 'https://twitter.com/okolodev'
  s.author            = { "Alexey Belkevich" => "belkevich.alexey@gmail.com" }
  s.source            = { :git => "https://github.com/belkevich/ocfuntime.git",
		                      :tag => s.version.to_s }
  s.requires_arc      = true

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"

  s.subspec 'Core' do |sp|
    sp.source_files = 'Classes/Core/**/*.{h,m}'
  end

 s.subspec 'Methods' do |sp|
   sp.source_files = 'Classes/Methods/**/*.{h,m}'
   sp.dependency 'OCFuntime/Core'
 end

 s.subspec 'Properties' do |sp|
   sp.source_files = 'Classes/Properties/**/*.{h,m}'
   sp.dependency 'OCFuntime/Core'
 end

 s.subspec 'Protocols' do |sp|
   sp.source_files = 'Classes/Protocols/**/*.{h,m}'
   sp.dependency 'OCFuntime/Core'
 end


 s.subspec 'Shared' do |sp|
   sp.source_files = 'Classes/Shared/*.{h,m}'
   sp.dependency 'OCFuntime/Core'
   sp.dependency 'ABMultiton'
 end

 s.subspec 'NSObject+OCFMethods' do |sp|
   sp.source_files = 'Classes/Categories/Methods/**/*.{h,m}'
   sp.dependency 'OCFuntime/Methods'
   sp.dependency 'OCFuntime/Shared'
 end

 s.subspec 'NSObject+OCFProperties' do |sp|
   sp.source_files = 'Classes/Categories/Properties/**/*.{h,m}'
   sp.dependency 'OCFuntime/Properties'
   sp.dependency 'OCFuntime/Shared'
 end

 s.subspec 'All' do |sp|
   sp.source_files = 'Classes/All/*.h'
   sp.dependency 'OCFuntime/NSObject+OCFMethods'
   sp.dependency 'OCFuntime/NSObject+OCFProperties'
   sp.dependency 'OCFuntime/Protocols'
 end

 s.default_subspecs = 'All'

end
