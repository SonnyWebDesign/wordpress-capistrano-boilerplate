desc 'Set permissions for folders and files after deploy'
task :file_permissions do
  on roles(:all) do
    execute "find #{fetch(:deploy_dir)}/ -type f -exec chmod 644 {} \\;"
    execute "find #{fetch(:deploy_dir)}/ -type d -exec chmod 755 {} \\;"
  end
end
