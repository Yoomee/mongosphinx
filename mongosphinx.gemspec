# MongoSphinx, a full text indexing extension for MongoDB using
# Sphinx.

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "yoomee-mongosphinx"
  spec.homepage = "http://github.com/yoomee/mongosphinx"
  spec.version = "0.1.5"
  spec.author = "Matt Atkins"
  spec.email = "matt@yoomee.com"
  spec.summary = "A full text indexing extension for MongoDB using Sphinx."
  spec.files = ["README.rdoc", "lib/mongo_sphinx.rb", "lib/multi_attribute.rb", "lib/mixins/properties.rb", "lib/mixins/indexer.rb", "lib/indexer.rb"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = []
  spec.extra_rdoc_files = ["README.rdoc"]
  spec.rdoc_options = ["--exclude", "pkg", "--exclude", "tmp", "--all", "--title", "MongoSphinx", "--main", "README.rdoc"]
end
