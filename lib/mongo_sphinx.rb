# MongoSphinx, a full text indexing extension for using
# Sphinx.
#
# This file contains the includes implementing this library. Have a look at
# the README.rdoc as a starting point.

begin
  require 'rubygems'
rescue LoadError; end
require 'mongo_mapper'
require 'riddle'

module MongoSphinx
  if (match = __FILE__.match(/.*mongo_sphinx-([0-9.-]*)/))
    VERSION = match[1]
  else
    VERSION = 'unknown'
  end
  
  # Check if Sphinx is running.
  #
  def self.sphinx_running?
    !!sphinx_pid && pid_active?(sphinx_pid)
  end

  def self.sphinx_pid
    if File.exists?(MongoSphinx::Configuration.instance.pid_file)
      File.read(MongoSphinx::Configuration.instance.pid_file)[/\d+/]
    else
      nil
    end
  end
end

require 'mongo_sphinx/multi_attribute'
require 'mongo_sphinx/configuration'
require 'mongo_sphinx/indexer'
require 'mongo_sphinx/mixins/indexer'
require 'mongo_sphinx/mixins/properties'


# Include the Indexer mixin from the original Document class of
# MongoMapper which adds a few methods and allows calling method indexed_with.

module MongoMapper # :nodoc:
  module Document # :nodoc:
    include MongoMapper::Mixins::Indexer
    module InstanceMethods
      include MongoMapper::Mixins::Properties
    end
    module ClassMethods
      include MongoMapper::Mixins::Indexer::ClassMethods
    end
  end
end
