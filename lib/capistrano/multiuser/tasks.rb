require 'capistrano'

Capistrano::Configuration.instance.load do

  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  set_default(:user) { ENV['DEPLOY_USER'] }
  set_default(:deploy_group) { ENV['DEPLOY_GROUP']||"#{fetch(:application)}-deployers" }

  namespace :multiuser do

    desc 'chown the deploy directory'
    task :chown, roles: :app do
      run "chown -R #{ENV['DEPLOY_USER']}:#{fetch(:deploy_group)} #{fetch(:deploy_to)}"
    end

    desc 'chmod the deploy directory'
    task :chmod, roles: :app do
      run "chmod -R 2775 #{fetch(:deploy_to)}"
    end

    task :default do
      chown
      chmod
    end

    after 'deploy:symlink', 'multiuser:default'

  end

end
