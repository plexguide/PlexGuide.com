# Extra Tips
I will use this area to put some lessons learned and something that I wish I would have known prior

## Directory Structure
Linux is easy and complicated at the same time to understand regarding the file structure.  

#### Windows Users
If your a windows user, it may seem difficult, but it's not. Understand that the linux file structure DOES NOT USE letters.  Just paths.  If you have ever used a MAC, you will notice that there are no drive letters also

### Directory
So what confused me was that when I started, you will normally be a user or SUDO user.  If you want to go to the root or core of the drive like Windows C:/ you will type the following:

```sh
# To go to the root or core directory
cd /
# Command to see what is inside the root or core directory
ls
```

You will notice here that there are serveral folders.  For the awesome plex server, the two that you have to pay attention to are /opt and /tmp.

- /opt:  This is generally where scripts are saved or where programs are saved such as the Windows Programs folder in windows
- /tmp:  A good place to download temporary stuff

In addition, the following are also good to know:

- /root: The home folder for the root user
  - You must be the root user to see this folder
  - ./config is a hidden folder where most of your configurations for some programs are stored.  To see it, type:
  
  ```sh
  ls -la
  ```
  
- /home:  This is where the home folder of the users are, such as in windows.
  - Mistake #1: You can install scripts or run stuff under your user name, but it's not ideal.  It's what I did at first
  - Mistake #2: Understand how to change the permissions of folders outside of /home to execute

## Random Note

https://uguu.se - To post backups for wget

More will be added later
