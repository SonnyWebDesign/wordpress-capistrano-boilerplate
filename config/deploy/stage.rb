# the server folder where we want to deploy the project
set :deploy_dir, "/home/#{fetch(:user)}/capistrano/#{fetch(:application)}"
set :deploy_to, "#{fetch(:deploy_dir)}/stage"

# deploy the stage environment to stage.application_name so the live url will be something like www.YOUR_DOMAIN.com/stage.application
set :application_name, "stage.#{fetch(:application)}"

# link the config.php and .htaccess using the one stored in the shared folder
set :linked_files, fetch(:linked_files, []).push('config.php', '.htaccess')

role :web, "#{fetch(:server_name)}"

server "#{fetch(:server_name)}",
user: "#{fetch(:user)}",
  roles: %w{web}

set :branch, 'develop'
