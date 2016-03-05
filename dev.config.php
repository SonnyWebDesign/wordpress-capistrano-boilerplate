<?php
define('DB_NAME', 'wordpress_capistrano_boilerplate');
define('DB_USER', 'root');
define('DB_PASSWORD', 'root');
define('DB_HOST', 'localhost');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
 define('AUTH_KEY',         'put your unique phrase here');
 define('SECURE_AUTH_KEY',  'put your unique phrase here');
 define('LOGGED_IN_KEY',    'put your unique phrase here');
 define('NONCE_KEY',        'put your unique phrase here');
 define('AUTH_SALT',        'put your unique phrase here');
 define('SECURE_AUTH_SALT', 'put your unique phrase here');
 define('LOGGED_IN_SALT',   'put your unique phrase here');
 define('NONCE_SALT',       'put your unique phrase here');

// Display PHP errors
@ini_set( 'display_errors', true );
// Store all the errors inside the default server error.log if no `error_log` defined
@ini_set( 'log_errors', true );
// Define where you want to store the error log file on your server side
@ini_set( 'error_reporting', E_ALL );
@ini_set('error_log', dirname(__FILE__) . '/php-errors.log');
// Turns WordPress debugging on
define( 'WP_DEBUG', true );
// Display errors on screen
define( 'WP_DEBUG_DISPLAY', true );
// Tells WordPress not to log everything to the /wp-content/debug.log
define( 'WP_DEBUG_LOG', false );
// Disable the editing of theme and plugin files
// define( 'DISALLOW_FILE_EDIT', true );
// Disable installing new themes and plugins, and updating them
// define( 'DISALLOW_FILE_MODS', true );
