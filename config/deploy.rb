# config valid only for current version of Capistrano
lock '3.4.0'

# replace Wordpress-Capistrano-Boilerplate with your application name
set :application, 'Wordpress-Capistrano-Boilerplate'

# the user name for SSH
set :user, 'deploy'

# your server name
set :server_name, 'MY_WEBSERVER.com'

# the public folder in where you want to create the symbolic link to the deployed release
set :public_html, "/home/#{fetch(:user)}/public_html"

set :scm, :git
# the Git repository you want to deploy with Capistrano
set :repo_url, 'git@github.com:andreasonny83/Wordpress-Capistrano-Boilerplate.git'
# SubmoduleStrategy is used for including all the related submodule (eg. WordPress)
set :git_strategy, Capistrano::Git::SubmoduleStrategy

# The folder on your server that Capistrano will use as a temporary one
set :tmp_dir, "/home/#{fetch(:user)}/tmp"

set :format, :pretty
set :log_level, :info
set :bundle_binstubs, nil

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# make sure the destination fodler exists and the user has write permissions on it
before :deploy, :check_write_permissions
# set the default wordpress permission in the deployed path (644 on all the files and 755 on all the folders inside the deployed project)
after :deploy, :file_permissions
# remove all the development and deployment files and folder from inside the release path
after :file_permissions, :clean_folder
# create a symbolik link in your public_html folder pointing to the latest release project
after :clean_folder, :create_symlink

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end
end
