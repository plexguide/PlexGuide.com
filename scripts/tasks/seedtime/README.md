# deluge-seedtime
Deluge plugin to stop torrents after seeding for a certain amount of time.

# Build instructions
1. Clone the repo
1. From the command line, navagate to repo directory
1. Run command `python setup.py bdist_egg`
  * note: If your default python version is different from the deluge python version (2.7), then you will have to change `python` to reference the correct binary.
1. check the `dist` folder, you should see a `SeedTime*.egg`, this is file to choose when installing the plugin from deluge

# Install instructions
1. Open Deluge
1. Open Preferences
1. Select `Plugings` from the Categories on the left
1. Press the `Install Plugin` button
![Installing SeedTime](https://cloud.githubusercontent.com/assets/8310169/14019965/7dcf179e-f1ab-11e5-93be-c9550559e351.png)
1. Choose the SeedTime*.egg plugin file
1. Check the box in front of the SeedTime plugin to enable it
![Enabling SeedTime](https://cloud.githubusercontent.com/assets/8310169/14019962/7c1462c4-f1ab-11e5-812f-5e43b6b333ac.png)

# Using the plugin
1. Select SeedTime from the Categories on the left
1. Setup filters
  1. Press `Add` to create a new filter
  1. Press the cell in the `Field` column on the row of the new filter, select label or tracker depending on what you want to filter on.
    * Note: The Label plugin needs to be enabled for any label filters in SeedTime to have an effect
  1. Change the `Filter` cell to appropriate RegEx
  1. Set the `Stop Seed Time` as a number or days
  ![Image of Yaktocat](https://cloud.githubusercontent.com/assets/8310169/14019957/7a73b6b8-f1ab-11e5-9dc5-7be69f1f5cb7.png)
  1. Add/Remove more filters as you want. Filters are evaluated from top to bottom, press the up and down buttons rearrange the list.
  1. Press `OK`
  1. Newly added torrents will have appropriate stop seed time set
  ![Image of Yaktocat](https://cloud.githubusercontent.com/assets/8310169/14019955/7783c858-f1ab-11e5-9fe1-9cc9e0b307c1.png)
