Pod::Spec.new do |s|

  s.name         = "WTAData"
  s.version      = "1.5.0"
  s.summary      = "WTAData is a wrapper for CoreData to handle commmon operations associated with managing a CoreData stack"

  s.description  = <<-DESC
                  WTAData provides a light-weight interface for setting up an asynchronous CoreData stack. WTAData utilizes two NSManagedObjectContexts: main and background, for achieving fast and performant core data access. The main context is generally used for read access to the core data stack. The main context updates automatically when changes are saved by the background managed object context. The background context is primarily used for performing saves in background threads, such as when a network call completes.
                   DESC

  s.homepage     = "https://github.com/willowtreeapps/WTAData"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "WillowTree, Inc." => "willowtreeapps.com" }
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => "https://github.com/willowtreeapps/WTAData.git", :tag => s.version }
  s.source_files  = "WTAData", "WTAData/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end
