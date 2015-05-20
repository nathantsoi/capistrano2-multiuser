# Capistrano 2 Multiuser Plugin

**Note: this plugin works only with Capistrano 2.** Plase check the capistrano
gem version you're using before installing this gem:
`$ bundle show | grep capistrano`

### About

Capistrano 2 Multiuser sets up deploy directories to allow multiple users,
sharing one group, to deploy a single Rails app.

### Installation

Add this to your `Gemfile`:

```
group :development do
  gem 'capistrano2-multiuser', require: false
end
```

Add this to your `config/deploy.rb`:

```
require 'capistrano-multiuser'
```

Install the gem with:

```
$ bundle install
```

### Configuration

When deploying with multiuser, developers should export DEPLOY_USER in their env:

```
export DEPLOY_USER=nathan
```

The plugin assumes this user's primary group is named `"#{appname}-deployers"`
and the deploy directory has the guid bit set. For example for apps deployed
inside of `/u/apps`:

```
sudo chmod -R 2775 /u/apps
```

The deployer's shared group can be overridden with ENV['DEPLOY_GROUP'] or in the app's capistrano config with set(:deployer_group). Only one is necessary as this plugin looks for either:

```
# if deploy_group is not set, we look for it in the env
set(:deploy_group) { ENV['DEPLOY_GROUP']||"#{fetch(:application)}-deployers" }
```

The plugin will set the deploy user to the value of this environment variable.
This user should exist on the target machine and should share a group with all
other deployers.

### Issues

If you see errors such as this in the log:

```
chown: changing ownership of ‘/u/apps/myapp/shared/log/somelog.log’
Operation not permitted
```

The last user who deployed or accessed these files didn't play nicely. You'll need to go in as root or the owner of these files and either run:

```
be cap production multiuser
```

or when ssh'd in, manually reset permissions, substituting your users and deploy path as appropriate

```
chown -R #{ENV['DEPLOY_USER']}:#{fetch(:deploy_group)} #{fetch(:deploy_to)}
chmod -R 2775 #{fetch(:deploy_to)}
```

### License

[MIT](LICENSE.md)
