![N](https://preview.ibb.co/gdXE0m/Snip20171029_22.png)


# Install an Apache server
This will allow you to build a website on top of your IP or domain.

## Basic Install

```sh
sudo apt-get update
sudo apt-get install apache2

# Verify System Install
sudo systemctl status apache2
```

### Tips

- Find out your IP Address
  - hostname -I

- Run this command after making configuration changes
  - sudo systemctl reload apache2

## Install Apache Lamp

### Install MYSQL

```sh
sudo apt-get install mysql-server
# Type a password for root-mysql and remember it! You need it for the next guide

# secure your install
sudo mysql_secure_installation
```

## PHP
Installing PHP
```sh
sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql
```

If a user requests a directory from the server, Apache will first look for a file called index.html. We want to prefer PHP files (for wordpress), so we'll make Apache look for an index.php file first.

```sh
sudo nano /etc/apache2/mods-enabled/dir.conf
```

You will see

```sh
<IfModule mod_dir.c>
    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
</IfModule>
```

Make sure it looks like this now

```sh
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

Reload the server to ensure that it works

```sh
# reload the apache server
sudo systemctl restart apache2
```
