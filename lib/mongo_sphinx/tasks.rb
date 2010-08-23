require 'fileutils'

namespace :mongo_sphinx do
  task :app_env do
    if defined?(RAILS_ROOT)
      Rake::Task[:environment].invoke
      
      if defined?(Rails.configuration)
        Rails.configuration.cache_classes = false
      else
        Rails::Initializer.run { |config| config.cache_classes = false }
      end
    end
    
    Rake::Task[:merb_env].invoke    if defined?(Merb)
  end
  
  desc "Output the current Mongo Sphinx version"
  task :version => :app_env do
    puts "Mongo Sphinx v" + MongoSphinx.version
  end
  
  desc "Stop if running, then start a Sphinx searchd daemon using Mongo Sphinx's settings"
  task :running_start => :app_env do
    Rake::Task["mongo_sphinx:stop"].invoke if sphinx_running?
    Rake::Task["mongo_sphinx:start"].invoke
  end
  
  desc "Start a Sphinx searchd daemon using Mongo Sphinx's settings"
  task :start => :app_env do
    config = MongoSphinx::Configuration.instance
    
    FileUtils.mkdir_p config.searchd_file_path
    raise RuntimeError, "searchd is already running." if sphinx_running?
    
    Dir["#{config.searchd_file_path}/*.spl"].each { |file| File.delete(file) }
    
    config.controller.start
    
    if sphinx_running?
      puts "Started successfully (pid #{sphinx_pid})."
    else
      puts "Failed to start searchd daemon. Check #{config.searchd_log_file}"
    end
  end
  
  desc "Stop Sphinx using Mongo Sphinx's settings"
  task :stop => :app_env do
    unless sphinx_running?
      puts "searchd is not running"
    else
      config = MongoSphinx::Configuration.instance
      pid    = sphinx_pid
      config.controller.stop
      puts "Stopped search daemon (pid #{pid})."
    end
  end
  
  desc "Restart Sphinx"
  task :restart => [:app_env, :stop, :start]
  
  desc "Generate the Sphinx configuration file using Mongo Sphinx's settings"
  task :configure => :app_env do
    config = MongoSphinx::Configuration.instance
    puts "Generating Configuration to #{config.config_file}"
    config.build
  end
  
  desc "Index data for Sphinx using Mongo Sphinx's settings"
  task :index => :app_env do
    config = MongoSphinx::Configuration.instance
    unless ENV["INDEX_ONLY"] == "true"
      puts "Generating Configuration to #{config.config_file}"
      config.build
    end
    
    FileUtils.mkdir_p config.searchd_file_path
    config.controller.index :verbose => true
  end
  
  desc "Reindex Sphinx without regenerating the configuration file"
  task :reindex => :app_env do
    config = MongoSphinx::Configuration.instance
    FileUtils.mkdir_p config.searchd_file_path
    puts config.controller.index
  end
  
  desc "Stop Sphinx (if it's running), rebuild the indexes, and start Sphinx"
  task :rebuild => :app_env do
    Rake::Task["mongo_sphinx:stop"].invoke if sphinx_running?
    Rake::Task["mongo_sphinx:index"].invoke
    Rake::Task["mongo_sphinx:start"].invoke
  end
end

namespace :ms do
  desc "Output the current Mongo Sphinx version"
  task :version => "mongo_sphinx:version"
  desc "Stop if running, then start a Sphinx searchd daemon using Mongo Sphinx's settings"
  task :run     => "mongo_sphinx:running_start"
  desc "Start a Sphinx searchd daemon using Mongo Sphinx's settings"
  task :start   => "mongo_sphinx:start"
  desc "Stop Sphinx using Mongo Sphinx's settings"
  task :stop    => "mongo_sphinx:stop"
  desc "Index data for Sphinx using Mongo Sphinx's settings"
  task :in      => "mongo_sphinx:index"
  task :index   => "mongo_sphinx:index"
  desc "Reindex Sphinx without regenerating the configuration file"
  task :reindex => "mongo_sphinx:reindex"
  desc "Restart Sphinx"
  task :restart => "mongo_sphinx:restart"
  desc "Generate the Sphinx configuration file using Mongo Sphinx's settings"
  task :conf    => "mongo_sphinx:configure"
  desc "Generate the Sphinx configuration file using Mongo Sphinx's settings"
  task :config  => "mongo_sphinx:configure"
  desc "Stop Sphinx (if it's running), rebuild the indexes, and start Sphinx"
  task :rebuild => "mongo_sphinx:rebuild"
end

def sphinx_pid
  MongoSphinx.sphinx_pid
end

def sphinx_running?
  MongoSphinx.sphinx_running?
end
