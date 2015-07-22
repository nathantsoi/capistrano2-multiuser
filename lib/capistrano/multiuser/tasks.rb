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
      # we can only update the files we own, if everyone does this though, it should be fine
      run "chgrp -R #{fetch(:deploy_group)} #{fetch(:deploy_to)}; true"
    end

    desc 'chmod the deploy directory'
    task :chmod, roles: :app do
      run "chmod -R 2775 #{fetch(:deploy_to)}; true"
    end

    task :default do
      chown
      chmod
    end

    after 'deploy:symlink', 'multiuser:default'

  end

end
