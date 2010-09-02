# MongoSphinx, a full text indexing extension for MongoDB using
# Sphinx.

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "yoomee-mongosphinx"
  spec.homepage = "http://github.com/yoomee/mongosphinx"
  spec.version = "0.1.10"
  spec.author = "Matt Atkins"
  spec.email = "matt@yoomee.com"
  spec.summary = "A full text indexing extension for MongoDB using Sphinx."
  spec.files = ["README.rdoc", "lib/mongosphinx.rb", "lib/mongosphinx/tasks.rb", "lib/mongosphinx/multi_attribute.rb", "lib/mongosphinx/mixins/properties.rb", "lib/mongosphinx/mixins/indexer.rb", "lib/mongosphinx/indexer.rb", "lib/mongosphinx/configuration.rb"]
  spec.require_path = "lib"
  spec.has_rdoc = true
  spec.executables = []
  spec.extra_rdoc_files = ["README.rdoc"]
  spec.rdoc_options = ["--exclude", "pkg", "--exclude", "tmp", "--all", "--title", "MongoSphinx", "--main", "README.rdoc"]
end
