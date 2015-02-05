Pod::Spec.new do |s|
  s.name         = "WTAData"
  s.version      = "1.2.0"
  s.summary      = "WTAData is a wrapper for CoreData to handle commmon operations associated with managing a CoreData stack"
  s.license      = "Proprietary"
  s.author       = { "WillowTree, Inc." => "willowtreeapps.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/willowtreeapps/WTAData.git", :tag => s.version }
  s.source_files  = "WTAData", "WTAData/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end
