# Installing Wordpress
A simple program to make a dynamic interface including the ability to create themes

## Establishing MYSQL Database

```sh
# Log in to mysql root

mysql -u root -p
# Enter the root password for MYSQL; not your SSH login

CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

### Change the following by copying next line to a textbad and change out the following below
# Change (wordpress) to your database name - good to change for security
# Change (wordpressuser) change to what you can remember
# Change (password) to something strong and something that you can remember

GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';

FLUSH PRIVILEGES;

# Exit MYSQL
EXIT;
```

### Add important MYSQL extensions

```sh
sudo apt-get update
sudo apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
sudo systemctl restart apache2
```

### Enable .htaccess overrides

```sh
sudo nano /etc/apache2/apache2.conf
```

- Add this to the very bottom of the file

```sh
<Directory /var/www/html/>
    AllowOverride All
</Directory>
```

- Press CTRL+X to save

```sh
# Enable rewrite module
sudo a2enmod rewrite

# Check for errors, should say [OK]
sudo apache2ctl configtest

# Restart the APACHE server due to configuration changes
sudo systemctl restart apache2sudo systemctl restart apache2
```

## Installing WordPress

```sh
# Can copy and paste the entire block
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html
```

### Assigning Permissions 

```sh
# Change the YOURUSERNAME line below - You can copy and paste entire block after
sudo chown -R YOURUSERNAME:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins

# Securing your Config File
# Type the following to generate SALT values (it's security stuff)
curl -s https://api.wordpress.org/secret-key/1.1/salt/

# Take the output and copy into a wordpad and then type
sudo nano /var/www/html/wp-config.php

# Scroll down several lines until you see tons of define lines
# Delete the default crap and paste each one of your values in
# Now scroll back up and enter your configuration information; ones you REMEMBERED from the MYSQL setup
# Change only DB_NAME, DB_USER, and DB_PASSWORD only!
```

- Press CTRL+X and Save 

## Finishing Up
- Now type your http://ipv4address|domain
- You should now see a wordpress install
- If you receive a CONNECTION ERROR, double check your password, username, and database name
  - Trust me... I had to redo twice
- Create a strong username and password!

## Upgrade Wordpress - 

```sh
# Wordpress will not upgrade for security reasons, so if you need to ever upgrade run this line
sudo chown -R www-data /var/www/html

# Once done, lock it back down - Tip: Change YOURUSERNAME
sudo chown -R YOURUSERNAME /var/www/html

```

- Recommended Theme: https://theme4press.com/ (.evolve Plus) (You get your moneys worth an adapts via mobile and tons of options)

## (Optional - Recommend) Change PHP Limits
- If you are uploading a theme and receive an exceed error size, the next steps are for you.

```sh
sudo nano /var/www/html/.htaccess
# add this line above </IfModule>: php_value upload_max_filesize 100M

sudo nano /var/www/html/wp-config.php
# add this to very bottom: define('FS_METHOD', 'direct');
```

- Once you upload this, comment it out by adding a #in front of define; it's good for security.
- If you need to upload again in future, remove the # and repeat the process

## Final Notes

- Visit http://ipv4address and you should see wordpress loadup
- Follow the Wizard and create a USER & PW you can memorize
- Customize easily by installing templates
  - If template does not upload do to exceed size message, follow instructions above
  - Recommend Template: Evolve ($39) https://theme4press.com/evolve-multipurpose-wordpress-theme/
- If install evolve, you need to follow the php limit instructions above
