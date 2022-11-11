platform :ios, '14.0'

target 'WhatToWatch' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WhatToWatch
  pod 'Alamofire', '~> 5.6'
  pod 'AlamofireImage', '~> 4.2'
  
  target 'WhatToWatchTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WhatToWatchUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end

inhibit_all_warnings!
