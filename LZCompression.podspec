Pod::Spec.new do |s|

  s.name         = "LZCompression"
  s.version      = "1.0.0"
  s.summary      = "LZ-based compression algorithm for Objective-C."

  s.description  = <<-DESC
                   An Objective-C implementation of lz-string for Javascript (see http://pieroxy.net/blog/pages/lz-string/index.html)
                   DESC

  s.homepage     = "https://github.com/TapMesh/LZCompression"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "bobwieler" => "bob.wieler@tapmesh.com" }
  s.source       = { :git => "https://github.com/TapMesh/LZCompression", :tag => "1.0.0" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true

end
