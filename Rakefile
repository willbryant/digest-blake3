require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :compile do
  puts "Compiling ext/digest/blake3/blake3.o"
  system('cd ext/digest/blake3 && ruby extconf.rb && make')
end

task :default => [:compile, :test]
