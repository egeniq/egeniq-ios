Pod::Spec.new do |s|
  s.name         = "Egeniq"
  s.version      = "0.2.0"
  s.summary      = "Egeniq Library for iOS projects"

  s.description  = <<-DESC
  Egeniq Library for iOS projects
  ===============================

  This project contains some of the utility classes we've developed to make our lives easier. If they make our lives easier, they may also make somebody else happy, so we've decided to make them publicly available.

  As-is, no warranties whatsoever, use at your own risk, etc. etc.

  Pull requests with improvements are very much appreciated!

  License: Apache License 2.0 (See LICENSE file)

  Todo:
  * Overview of what's in here and what you'd use it for
  * Clean up documentation (especially headers)

  Have fun!

  The Egeniq Team
  http://www.egeniq.com
                   DESC

  s.homepage     = "http://github.com/egeniq/egeniq-ios/"

  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }


  s.authors      = { "Peter Verhage" => "peter@egeniq.com",
                     "Ivo Jansch" => "ivo@egeniq.com",
                     "Thijs Damen" => "thijs@egeniq.com",
                     "Johan Kool" => "johan@egeniq.com",
                     "Felix De Vliegher" => "felix@egeniq.com"}

  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/egeniq/egeniq-ios.git", :tag => s.version.to_s }

  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  s.frameworks = 'CoreText', 'UIKit', 'QuartzCore', 'CoreData', 'Foundation', 'SystemConfiguration'
  s.requires_arc = false

end
