# The-Awesome-Plex-Server

Google Directories

Before you start anything, you need to go to your Google Drive and create a root folder called zilch and then within zilch, create two subfolders called movies and tv.  So you should have something like this below:

zilch > movies
zilch > tv

This whole guide is based on this setup, so if you skip or forget, you’ll have to manually change everything.

SSH

Warning:  May need to Install SSH on your machine if you are unable to connect via Command Line.

Download and install Ubuntu 16.04 on your machine or through a virtual machine.  You may have to install SSH on your machine if you want to reach it via command remotely.  If you have access to the GUI, you can right click the desktop and select “Open Terminal”.

If you are installing Ubuntu as a VM, you need to install ssh (or you can use the GUI and terminal, but you may as well practice).  Write down what your IP address is or know it.  If you cannot find it, within terminal; use the command [ifconfig].

Before you start, you need to know the ip address of your machine.  You can accomplish this by typing “ifconfig” on the machine or through putty access remotely.

If Running Ubuntu VMWare:   I would recommend to select the bridge network adapter and then assign a static ip address either through your router (fixed MAC Address) or through the virtual adapter itself once on the machine.  If you fail to do so, you will run into many issues on Plex not being able to reach outside the network.

To access your Ubuntu installation via SSH, download a program called Putty.
