require "bundler/gem_tasks"

rule ".rb" => ".xml" do |t|
  sh "../ffi-swig-generator/bin/ffi-gen #{t.prerequisites.first} #{t.name}"
end

rule ".xml" => ".i" do |t|
  sh "swig -I/usr/include -xml -o #{t.source.sub(/\.i$/, ".xml")} #{t.source}"
end
