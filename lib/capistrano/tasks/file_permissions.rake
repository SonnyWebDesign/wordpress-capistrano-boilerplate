desc 'Set permissions for folders and files after deploy'
task :file_permissions do
  on roles(:all) do
    execute "find #{fetch(:release_path)}/ -type f -exec chmod 644 {} \\;"
    execute "find #{fetch(:release_path)}/ -type d -exec chmod 755 {} \\;"
  end
end
