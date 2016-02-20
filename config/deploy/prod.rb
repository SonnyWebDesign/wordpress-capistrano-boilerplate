# the server folder where we want to deploy the project
set :deploy_dir, "/home/#{fetch(:user)}/capistrano/#{fetch(:application)}"
set :deploy_to, "#{fetch(:deploy_dir)}/prod"

# deploy the production environment to application_name so the live url will be something like www.YOUR_DOMAIN.com/application
# for deploying directly inside your public_html folder you will need to change the create_symlink.rake file
set :application_name, "#{fetch(:application)}"

# link the config.php and .htaccess using the one stored in the shared folder
set :linked_files, fetch(:linked_files, []).push('config.php', '.htaccess')

role :web, "#{fetch(:server_name)}"

server "#{fetch(:server_name)}",
user: "#{fetch(:user)}",
  roles: %w{web}

set :branch, 'master'
