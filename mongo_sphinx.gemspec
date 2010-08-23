# MongoSphinx, a full text indexing extension for MongoDB using
# Sphinx.

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "yoomee-mongo_sphinx"
  spec.homepage = "http://github.com/yoomee/mongosphinx"
  spec.version = "0.1.6"
  spec.author = "Matt Atkins"
  spec.email = "matt@yoomee.com"
  spec.summary = "A full text indexing extension for MongoDB using Sphinx."
  spec.files = ["README.rdoc", "mongo_sphinx.rb", "lib/mongo_sphinx.rb", "lib/mongo_sphinx/tasks.rb", "lib/mongo_sphinx/multi_attribute.rb", "lib/mongo_sphinx/mixins/properties.rb", "lib/mongo_sphinx/mixins/indexer.rb", "lib/mongo_sphinx/indexer.rb", "lib/mongo_sphinx/configuration.rb"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = []
  spec.extra_rdoc_files = ["README.rdoc"]
  spec.rdoc_options = ["--exclude", "pkg", "--exclude", "tmp", "--all", "--title", "MongoSphinx", "--main", "README.rdoc"]
end
