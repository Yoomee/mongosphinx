require 'erb'
require 'singleton'

module MongoSphinx
  # This class both keeps track of the configuration settings for Sphinx and
  # also generates the resulting file for Sphinx to use.
  # 
  # Here are the default settings, relative to RAILS_ROOT where relevant:
  #
  # config file::           config/#{environment}.sphinx.conf
  # searchd log file::      log/searchd.log
  # query log file::        log/searchd.query.log
  # pid file::              log/searchd.#{environment}.pid
  # searchd files::         db/sphinx/#{environment}/
  # address::               127.0.0.1
  # port::                  9312
  # allow star::            false
  # min prefix length::     1
  # min infix length::      1
  # mem limit::             64M
  # max matches::           1000
  # morphology::            nil
  # charset type::          utf-8
  # charset table::         nil
  # ignore chars::          nil
  # html strip::            false
  # html remove elements::  ''
  # searchd_binary_name::   searchd
  # indexer_binary_name::   indexer
  #
  # If you want to change these settings, create a YAML file at
  # config/sphinx.yml with settings for each environment, in a similar
  # fashion to database.yml - using the following keys: config_file,
  # searchd_log_file, query_log_file, pid_file, searchd_file_path, port,
  # allow_star, enable_star, min_prefix_len, min_infix_len, mem_limit,
  # max_matches, morphology, charset_type, charset_table, ignore_chars,
  # html_strip, html_remove_elements, delayed_job_priority,
  # searchd_binary_name, indexer_binary_name.
  #
  # I think you've got the idea.
  # 
  # Each setting in the YAML file is optional - so only put in the ones you
  # want to change.
  #
  # Keep in mind, if for some particular reason you're using a version of
  # Sphinx older than 0.9.8 r871 (that's prior to the proper 0.9.8 release),
  # don't set allow_star to true.
  # 
  class Configuration
    include Singleton

    attr_accessor :searchd_file_path, :allow_star,:app_root, :delayed_job_priority
    attr_accessor :version
    
    attr_accessor :source_options, :index_options
    
    attr_reader :environment, :configuration, :controller

    def initialize(app_root = Dir.pwd)
      self.reset
    end

    def self.configure(&block)
      yield instance
      instance.reset(instance.app_root)
    end

    def reset(custom_app_root=nil)
      if custom_app_root
        self.app_root = custom_app_root
      else
        self.app_root          = RAILS_ROOT if defined?(RAILS_ROOT)
        self.app_root          = Merb.root  if defined?(Merb)
        self.app_root        ||= app_root
      end

      @configuration = Riddle::Configuration.new
      @configuration.searchd.pid_file   = "#{self.app_root}/log/mongo_sphinx.searchd.#{environment}.pid"
      @configuration.searchd.log        = "#{self.app_root}/log/mongo_sphinx.searchd.log"
      @configuration.searchd.query_log  = "#{self.app_root}/log/mongo_sphinx.query.log"

      @controller = Riddle::Controller.new @configuration,
      "#{self.app_root}/config/#{environment}.mongo_sphinx.conf"

      self.address              = "127.0.0.1"
      self.port                 = 9312
      self.searchd_file_path    = "#{self.app_root}/db/mongo_sphinx/#{environment}"
      self.allow_star           = false
      self.delayed_job_priority = 0
      self.source_options  = {}
      self.index_options   = {
        :charset_type => "utf-8"
      }

      self.version = nil
      self.version ||= @controller.sphinx_version

      self
    end

    def self.environment
      Thread.current[:mongo_sphinx_environment] ||= begin
        if defined?(Merb)
          Merb.environment
        elsif defined?(RAILS_ENV)
          RAILS_ENV
        else
          ENV['RAILS_ENV'] || 'development'
        end
      end
    end

    def environment
      self.class.environment
    end

    def address
      @address
    end

    def address=(address)
      @address = address
      @configuration.searchd.address = address
    end

    def port
      @port
    end

    def port=(port)
      @port = port
      @configuration.searchd.port = port
    end

    def pid_file
      @configuration.searchd.pid_file
    end

    def pid_file=(pid_file)
      @configuration.searchd.pid_file = pid_file
    end

    def searchd_log_file
      @configuration.searchd.log
    end

    def searchd_log_file=(file)
      @configuration.searchd.log = file
    end

    def query_log_file
      @configuration.searchd.query_log
    end

    def query_log_file=(file)
      @configuration.searchd.query_log = file
    end

    def config_file
      @controller.path
    end

    def config_file=(file)
      @controller.path = file
    end

    def bin_path
      @controller.bin_path
    end

    def bin_path=(path)
      @controller.bin_path = path
    end

    def searchd_binary_name
      @controller.searchd_binary_name
    end

    def searchd_binary_name=(name)
      @controller.searchd_binary_name = name
    end

    def indexer_binary_name
      @controller.indexer_binary_name
    end

    def indexer_binary_name=(name)
      @controller.indexer_binary_name = name
    end

    def client
      client = Riddle::Client.new address, port
      client.max_matches = configuration.searchd.max_matches || 1000
      client
    end
  end
end