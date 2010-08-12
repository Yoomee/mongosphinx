# MongoSphinx, a full text indexing extension for MongoDB using
# Sphinx.

require 'rubygems'
require 'rake/gempackagetask'

require 'find'

spec = Gem::Specification.new do |spec|
  files = FileList['README.rdoc', 'mongosphinx.rb', 'tests/*.rb'].to_a

  Find.find('lib') { |path|
    files << path if not File.stat(path).directory? }

  spec.platform = Gem::Platform::RUBY
  spec.name = 'mongosphinx'
  spec.homepage = 'http://github.com/yoomee/mongosphinx'
  spec.version = '0.1.3'
  spec.author = 'Matt Atkins'
  spec.email = 'matt@yoomee.com'
  spec.summary = 'A full text indexing extension for MongoDB using Sphinx.'
  spec.files = files
  spec.require_path = '.'
  spec.test_files = Dir.glob('tests/*.rb')
  spec.has_rdoc = true
  spec.executables = nil
  spec.extra_rdoc_files = ['README.rdoc']
  spec.rdoc_options << '--exclude' << 'pkg' << '--exclude' << 'tmp' <<
    '--all' << '--title' << 'MongoSphinx' << '--main' << 'README.rdoc'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts 'Generated latest version.'
end

desc 'Remove directories "pkg" and "doc"'
task :clean do
  puts 'Remove directories "pkg" and "doc".'
  `rm -rf pkg doc`
end

desc 'Create rdoc documentation from the code'
task :doc do
  `rm -rf doc`

  puts 'Create rdoc documentation from the code'
  puts `(rdoc --exclude pkg --exclude tmp \
          --all  --title "MongoSphinx" README.rdoc lib mongosphinx.rb) 1>&2`
end

desc 'Update the mongosphinx.gemspec file with new snapshot of files to bundle'
task :gemspecs do
  puts 'Update the mongosphinx.gemspec file with new snapshot of files to bundle.'

  # !!Warning: We can't use spec.to_ruby as this generates executable code
  # which would break Github gem generation...

  template = <<EOF
# MongoSphinx, a full text indexing extension for MongoDB using
# Sphinx.

Gem::Specification.new do |spec|
  spec.platform = #{spec.platform.inspect}
  spec.name = #{spec.name.inspect}
  spec.homepage = #{spec.homepage.inspect}
  spec.version = "#{spec.version}"
  spec.author = #{spec.author.inspect}
  spec.email = #{spec.email.inspect}
  spec.summary = #{spec.summary.inspect}
  spec.files = #{spec.files.inspect}
  spec.require_path = #{spec.require_path.inspect}
  spec.has_rdoc = #{spec.has_rdoc}
  spec.executables = #{spec.executables.inspect}
  spec.extra_rdoc_files = #{spec.extra_rdoc_files.inspect}
  spec.rdoc_options = #{spec.rdoc_options.inspect}
end
EOF

  File.open('mongosphinx.gemspec', 'w').write(template)
end
