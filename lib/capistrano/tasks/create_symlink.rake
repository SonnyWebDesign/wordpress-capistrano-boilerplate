desc "Create a symbolic link in the public_html folder using the application name"
task :create_symlink do
  on roles(:all) do
    execute "rm -rf #{fetch(:public_html)}/#{fetch(:application_name)}"
    execute "ln -sf #{fetch(:release_path)} #{fetch(:public_html)}/#{fetch(:application_name)}"
  end
end
