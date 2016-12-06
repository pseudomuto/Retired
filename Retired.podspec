Pod::Spec.new do |s|
  s.name     = "Retired"
  s.version  = "3.0.0"
  s.summary  = "A simple framework to help recommend/force app updates and sunset old versions"
  s.homepage = "https://github.com/pseudomuto/Retired"
  s.license  = "MIT"
  s.author   = { "pseudomuto" => "david.muto@gmail.com" }

  s.source       = { git: "https://github.com/pseudomuto/Retired.git", tag: s.version.to_s }
  s.source_files = "Sources/**/*", "LICENSE"

  s.ios.deployment_target = "8.0"
  s.requires_arc = true
end
