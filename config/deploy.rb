# config valid only for current version of Capistrano
lock '3.4.0'

# replace Wordpress-Capistrano-Boilerplate with your application name
set :application, 'Wordpress-Capistrano-Boilerplate'

set :scm, :git
# set the repo_url to pointing to your Git project
set :repo_url, 'git@github.com:andreasonny83/Wordpress-Capistrano-Boilerplate.git'
# SubmoduleStrategy is used for including the WordPress submodule
set :git_strategy, Capistrano::Git::SubmoduleStrategy

set :format, :pretty
set :log_level, :info
# The folder on your server that Capistrano will use as a temporary one
set :tmp_dir, '/home/SSH_USER_NAME/tmp'

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

before :deploy, :check_write_permissions

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
