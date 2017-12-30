### Install X2Go server on linux

```sh
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:x2go/stable
sudo apt-get update
sudo apt-get install x2goserver x2goserver-xsession
sudo apt-get install xfce4
```

Install the X2Go client on you main pc/laptop
Once X2Go client is started you will need to add your remote server details to a New Session
In the Server box next to Host: put your servers IP
Next to Login: put your username you use
Then in the Session type box change from KDE to XFCE and click OK
Now you can double click the newly created session and put in your password.

Then once logged in do the following in a terminal window:-
- For editing text files
```sh
sudo apt-get install gedit
```
- An easier to use terminal emulator
```sh
sudo apt-get install gnome-terminal
```
- This is to install opera web browser
```sh
sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install opera-stable
```
Now go up to Applications in top right corner
Hover over Settings
Select Preferred Applications
For Web Browsing choose Opera
Then click on Utilities tab and change Terminal Emulator to Gnome terminal

Now go to localhost:32400/web in Opera so you can claim your Plex Media Server!

X2Go Client can be found https://wiki.x2go.org/doku.php/doc:newtox2go
