require 'capistrano'

Capistrano::Configuration.instance.load do

  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  set_default(:user) { ENV['DEPLOY_USER']||`whoami` }
  set_default(:deploy_group) { ENV['DEPLOY_GROUP']||"#{fetch(:application)}-deployers" }

  namespace :multiuser do

    desc 'chown the deploy directory'
    task :chown, roles: :app do
      # we can only update the files we own, if everyone does this though, it should be fine
      run "sudo /bin/chown -R #{fetch(:user)}:#{fetch(:deploy_group)} #{fetch(:deploy_to)}"
    end

    desc 'chmod the deploy directory'
    task :chmod, roles: :app do
      run "sudo /bin/chmod -R 2775 #{fetch(:deploy_to)}"
    end

    task :default do
      chown
      chmod
    end

    before 'deploy', 'multiuser:default'
    after 'deploy:symlink', 'multiuser:default'

  end

end
