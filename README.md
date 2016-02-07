# Capistrano Wordpress boilerplate
This is a tutorial project using WordPress as a submodule and Capistrano for deploying.

## Why Capistrano

Capistrano allows you to write your own deployment scripts. That means you can write scripts that deploy mysql databases, take backups, and most importantly, dynamically create environment specific WordPress configuration files.

## Installation

For setting up a brand new project, clone this project on your local machine with

    `git clone https://github.com/andreasonny83/Wordpress-Capistrano-Boilerplate.git`

And remove this origin repository from your working copy:

    cd Wordpress-Capistrano-Boilerplate
    git remote rm origin

This is because Capistrano clones a Git repository inside your hosting server meaning that you will need to create a brand new Git repository inside the cloned folder. You can also do that removing the `.git ` folder instead of `git remote rm origin`

Then, you need to add your new origin repository to your working copy with `git remote add origin <url_here>` or start a new Git repo with `git init`

### Install the Ruby dependencies

We are going to use [Bundler](http://bundler.io/). Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed.
If you don't have Bundler already installed in your machine, open a terminal window and run this command:

    gem install bundler

Then, from inside your project folder, run:

    bundle install && bundle update

This will install all the Gem dependencies required for Capistrano

## SSH

Capistrano deploys using SSH. Thus, you must be able to SSH (ideally with keys and ssh-agent) from the deployment system to the destination system for Capistrano to work.

You can test this using a ssh client, e.g. `ssh myuser@destinationserver`. If you cannot connect at all, you may need to set up the SSH server or resolve firewall/network issues.

If a password is requested when you log in, you may need to set up SSH keys. [GitHub has a good tutorial](https://help.github.com/articles/generating-an-ssh-key/) on creating these (follow steps 1 through 3). You will need to add your public key to ~/.ssh/authorized_keys on the destination server as the deployment user (append on a new line).

## WordPress as a submodule

This project uses WordPress as a git submodule which is super handy and helps keep your structure more modular.
You can even update WordPress straight from git with a quick `git fetch && git checkout 4.4.1` which helps for consistency across environments and between developers.

To add WordPress as a submodule in your project folder just run:

    git submodule add git://github.com/WordPress/WordPress.git wordpress

Then, `cd wordpress` and fetch all the available versions with `git fetch --tags && git tag`.
Now you can simply select the WordPress version you want with `git checkout {version_number}` (eg. `git checkout 4.1.1`)

## File structure

For Capistrano to be most effective you need to keep all your WordPress files in the repo.
Core files, plugins, and all. The best (and cleanest) way to do this is to sit your WordPress core in it's own directory and using a custom content folder for uploads, themes and plugins.

    /config/deploy.rb
    /config/deploy/prod.rb
    /config/deploy/stage.rb
    /content/plugins/
    /content/themes/
    /content/uploads/
    /wordpress/
    /lib/
    /lib/capistrano/tasks/access_check.rake
    .gitattributes
    .gitignore
    .htaccess
    Capfile
    dev-config.php
    Gemfile
    Gemfile.lock
    index.php
    wp-config.php

Your uploads directory should be git ignored as you don't want to version control or deploy them.

## Project Settings

Great, now you're almost ready for rendering our WordPress website.

First we need a database. Create or clone your local database and configure your `dev-config.php` with your settings.
`dev-config.php` will be only use on your local environment and it's already black-listed in the `.gitattributes`. This means it won't we deployed to your server folder.

In the `wp-settings.php` we already set some constants to a default value like `DB_CHARSET`, `DB_COLLATE` and `WPLANG`. Feel free to edit this file as you prefer.
In the same file, there is a section called `Custom Directory`, here we tell WordPress our new file structure.
We also try to include a `production-config.php`. This will contain your server database configuration and will be stored somewhere inside your server and not tracked by Git. We set a default path to `/../../production-config.php`, this means it will reside 2 folder above your project folder. This is assuming your production folder will be on `/var/www/public_html/Wordpress-Capistrano-Boilerplate`, your `production-config.php` will reside on `/var/www/production-config.php`. Feel free to edit this configuration as you prefer.

Now, if you have correctly configured your database and your dev-config.php you should be able to run your local environment using some PHP and MySQL tool like MAMP.

### .gitattributes

In this file, there is a list of `export-ignore` files. These are the files we don't want to deploy to our server side when we trigger a Capistrano deploy.
Feel free to edit this file with your custom settings.

## Capistrano

Now that we have completed the project structure, we can start thinking about the deployment process with Capistrano.

By default, this boilerplate allows you to run `cap deploy` to 2 different environments: `stage` and `prod`. prod is just and empty task and you can create you custom settings mocking the ones listed in the `stage.rb` file.

##### cofig/deploy.rb

This is the core of Capistrano. In here you can set up all the variables Capistrano will need for deploying your project.

* **application** : your application name. This will be used for creating a temporary folder on your server in where cloning the repository.
* **repo_url** : your Git repository url
* **tmp_dir** : the server path in where you want Capistrano to clone your repository (eg. /home/my_user_name/tmp ). Note: This should be outside of your `public_html` folder as we don't want to be a public access folder.

##### config/deploy/stage.rb and prod.rb

This is relative to the environment you want to deploy.
Feel free to create as many .rb files as you want inside this folder. You can then simply deploy one of them calling `cap {filename} deploy` (eg. `cap stage deploy`).


* **deploy_to** : the folder in where you want this task to deploy your project
* **role :web** : replace `YOUR_DOMAIN.com` with your domain name
* **server** : replace `YOUR_DOMAIN.com` with your domain name or IP address
* **SSH_USER_NAME** : the user name for ssh inside your server side
* **branch** : the git branch you want to deploy

## .htaccess
## wp-config
