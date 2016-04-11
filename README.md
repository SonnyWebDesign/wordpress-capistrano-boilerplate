# Wordpress Capistrano Boilerplate
This is a boilerplate project using WordPress as a submodule and Capistrano for deploying.

## Why Capistrano

Capistrano allows you to write your own deployment scripts. That means you can write scripts that deploy mysql databases, take backups, and most importantly, dynamically create environment specific WordPress configuration files.

## Installation

For setting up a brand new project, clone this project on your local machine with

    git clone --recursive https://github.com/SonnyWebDesign/wordpress-capistrano-boilerplate.git

And remove the origin repository from your working copy:

    cd wordpress-capistrano-boilerplate
    git remote rm origin

Then create a new Git repository and add the new origin to your working copy with

    git remote add origin <url_here>

or start a new Git repo with `git init`

### Install the Ruby dependencies

We are going to use [Bundler](http://bundler.io/). Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed.
If you don't have Bundler already installed in your machine, open a terminal window and run this command:

    gem install bundler

or, if you are on El Capitan:

    gem install bundler -n /usr/local/bin

Then, from inside your project folder, run:

    bundle install

This will install all the Gem dependencies required for Capistrano

## SSH

Capistrano deploys using SSH. Thus, you must be able to SSH (ideally with keys and ssh-agent) from the deployment system to the destination system for Capistrano to work.

You can test this using a ssh client, e.g. `ssh myuser@destinationserver`. If you cannot connect at all, you may need to set up the SSH server or resolve firewall/network issues.

If a password is required when you log in, you may need to set up SSH keys. [GitHub has a good tutorial](https://help.github.com/articles/generating-an-ssh-key/) on creating these (follow steps 1 through 3). You will need to add your public key to ~/.ssh/authorized_keys on the destination server as the deployment user (append on a new line).

## WordPress as a submodule

This project uses WordPress as a git submodule which is super handy and helps keep your structure more modular.
You can simply switch between different WordPress versions from Git with

    git checkout <WordPress version>

    eg.
    git checkout 4.4.2

Wordpress should be already present in your project directory as a submodule. Reach the WP folder with `cd wordpress` and fetch all the latest tags with `git fetch --tags && git tag`.
Now you can simply select the WordPress version you want to run in your project with `git checkout {version_number}` (eg. `git checkout 4.4.2`)

## File structure

For Capistrano to be most effective you need to keep all your WordPress files in the repo.
Core files, plugins, and all. The best (and cleanest) way to do this is to sit your WordPress core in it's own directory and using a custom content folder for uploads, themes and plugins.

    /config/deploy.rb
    /config/deploy/prod.rb
    /config/deploy/stage.rb
    /content/plugins/
    /content/themes/
    /content/uploads/ <-- or blogs.dir
    /wordpress/
    /lib/
    /lib/capistrano/tasks/check_write_permissions.rake
    /lib/capistrano/tasks/clean_folder.rake
    /lib/capistrano/tasks/create_symlink.rake
    /lib/capistrano/tasks/file_permissions.rake
    .gitignore
    Capfile
    dev.config.php
    prod.config.php
    Gemfile
    Gemfile.lock
    index.php
    wp-config.php

Your uploads directory should be git ignored as you don't want to version control or deploy them.

## Project Settings

Great, now you're almost ready for rendering your WordPress website.

First we need a database. Create or clone your local database, then copy `dev.config.php` to `config.php` and edit with your settings.

`dev.config.php` and `prod.config.php` are only guidelines for you to create your `config.php` files on all your environment. Make sure to remove these 2 files before committing to your Git repository.

`config.php` should only be used on your local environment and you should have another `config.php` with your server configuration inside your `linked_files` folder, but that is better explained in the `Server side` section of this file. For now just make sure not to deploy your `config.php` file. We already mentioned that inside the `.gitignore` file for you :sunglasses:

Inside `wp-config.php` we already set some constants to a default value like `DB_CHARSET`, `DB_COLLATE` and `WPLANG`. Feel free to edit this file with your custom settings.
In the same file, there is a section called `Custom Directory`, here we tell WordPress our new file structure.
We also need to require the `config.php`. This will contain your environment database configuration. On your server side, this will be stored inside your server `shared` folder from where Capistrano will be able to create a symbolic link inside your project folder so you don't need to do it manually.

Now, if you have correctly configured your database and your `config.php` you should be able to run your local environment using some PHP and MySQL tool like MAMP.

#### Be careful

We already defined a `.httaccess` sample file for you to use. Because the `RewriteBase` is set to `/`, your website is not supposed to run from a subfolder (eg. localhost or www.mywebsite.com). If your website is hosted on a subfolder like `localhost:8888/my_wordpress_website/` or `www.mywebsite.com/my_wordpress_website` you will need to change your `.httaccess` file defining your correct address.

## Capistrano

Now that we have completed the project structure, we can start thinking about the deployment process with Capistrano.

By default, this boilerplate allows you to run `bundle exec cap deploy` to 2 different environments: `stage` and `prod` where stage will deploy your `develop` branch and prod is pointing to your `master` one. All the configuration for the different environments are stored inside the correspondent `.rb` file inside your `config/deploy` folder.

##### cofig/deploy.rb

This is the core of Capistrano. In here you can set up all the variables Capistrano will need for deploying your project.

* **application** : your application name. This will be used for creating a temporary folder on your server in where cloning the repository.
* **user** : the user that will be used for ssh into your server and creating the deploy folder on it.
* **server_name** : your server URL name.
* **repo_url** : your Git repository url.
* **public_html** : The public folder from where Capistrano will create a symbolic link to your deployed release.
* **git_strategy** : This is used for deploy all the Git submodules related to the repository (like WordPress in this example).
* **tmp_dir** : the server path in where you want Capistrano to clone your repository (eg. /home/my_user_name/tmp ). Note: This should be outside of your `public_html` folder as we don't want to be a public access folder.

##### config/deploy/stage.rb and prod.rb

This is relative to the environment you want to deploy.
Feel free to create as many `.rb` files as you want inside this folder. You can then simply deploy one of them calling `bundle exec cap {filename} deploy` (eg. `bundle exec cap stage deploy`).

* **deploy_dir** : the folder in where you want to deploy your project.
* **deploy_to** : This is more specific to the current environment. Usually this is a subfolder of deploy_dir.
* **application_name** : this will be used for creating the symbolic link in your public folder
* **linked_files** : these files will be symlinked from your shared folder inside your project folder
* **branch** : the git branch you want to deploy

## Server side

Because the `linked_files` array is pointing to `config.php` and `.htaccess`, you will need to upload these 2 files inside your shared folder on your server before deploying your project, otherwise an error will be triggered and the deploy will be cancelled.
You can copy the .htaccess from this project inside your `shared` folder and also create a copy of `prod.config.php` to use as your deployment config.php.
The shared folder will be created inside your `deploy_to` path followed by `shared` (eg. home/my_user/capistrano/wordpress-capistrano-boilerplate/stage/shared)

## Development with Gulp

First of all, install all the Node dependencies with:

    npm install

We've already provided to place a `theme-dev` folder in your project's root directory.

The generated distribution folder will be place under `content/themes/{theme name}` where `{theme name}` is the name defined in your `package.json` file under `themeName` (by default this is set to myTheme).

Place your development theme files inside the `theme-dev` folder and, once you're happy with that, run the following Gulp tasks to compile your project:

 - gulp : this will create a development theme under your `content/themes` directory

 - gulp watch : start developing and the file changes you made inside your `theme-dev` folder will be automatically detected by Gulp and a compiled in your theme folder

 - gulp build : create a distribution version under your `content/theme` directory.


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## License

The code and the documentation are released under the [MIT License](http://sonnywebdesign.mit-license.org).

## Changelog

Changelog available [here](https://github.com/SonnyWebDesign/wordpress-capistrano-boilerplate/blob/master/CHANGELOG.md)
