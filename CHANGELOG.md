# Changelog

All notable changes to the core project will be added to this repo. For changes to PGClone, see [PGClone Changelog](https://github.com/PGBlitz/PGClone/blob/v8.6/CHANGELOG.md).

## [8.7.5] - 2019-07-22

**Bugfixes**

- Fixes cname issues when rebuilding traefik

## [8.7.4] - 2019-07-21

**Bugfixes**

- Fixes cname prompt only doing the first app when queuing multiapps.

## [8.7.3] - 2019-07-21

**Bugfixes**

- Fixes portainer validation checks if you are using a custom cname.

## [8.7.2] - 2019-07-21

**Bugfixes**

- Fixes error when cname is not set while displaying endbanner after app install.

## [8.7.1] - 2019-07-20

**Bugfixes**

- Fixes bug with menu not showing appname in header 
- Adds input validation for port
- Blank entry in external port now resets port to app default

## [8.7.0] - 2019-07-20

**New features**

- Custom subdomain and external port can now be set during app install! You can now choose your own app url and still optionally use the appname (default) url.
  - You can still use `appname.mydomain.com`, add or keep the cname for `appname` in your DNS settings.
  - If you set a custom subdomain, you must add the matching cname to your dns.
  - If you no longer want to use `appname.mydomain.com` after setting a custom cname, remove the `appname` cname record from your DNS settings.
  - Internal app urls and port do not change, it remains the appname.
- Quick Deploy for VFS Option changes! Quickly reload services to use vfs settings changes without needing full deploy.
  - Requires a one time full PGClone deploy to update your services to support this new feature, otherwise it won't have any affect.
- Menu formatting and consistency updates

## [8.6.10] - 2019-07-19

**New features**

- Plex install has been updated to remove the Plex pass / public prompt. It will now use the standard image chooser prompt other apps use.
  - Use the latest image for rapid Plex server start times.
  - Prior to this change, all images were compiled and built on container start.
  - The beta image is for PlexPass users only. Plex renamed this edition from `PlexPass` to `beta`.
  - The beta image is compiled and built on container start, which takes over 5 minutes for Plex to start.
  - Plex officially does not offer a pre-compiled beta image or we would use that instead.
- disable ansible deprecation warnings when updating ansible.

**Bugfixes**

- Fixes NOT-SET being displayed in main menu

## [8.6.9] - 2019-07-18

**New features**

- type `q` to exit is now supported on prompts that expect typing 'exit'
- type `a` to deploy is now supoorted on prompts that expect typing 'deploy'
- type `backup` or a to backup appdata in pgvault (typing deploy still works)
- type `restore` or a to restore appdata in pgvault (typing deploy still works)

## [8.6.8] - 2019-07-18

**New features**

- Upgrade docker, ansible, and pip to latest versions.

**Bugfixes**

- Fixes issue with rebuilding community apps when using portguard
- Fixes issue with rebuilding community apps changing the processing disk.

## [8.6.7] - 2019-07-17

**Bugfixes**

- Updated emergency no space shutdown script to stop additional downloaders in the community apps.

## [8.6.6] - 2019-07-09

**Bugfixes**

- Fixes PGVault apps listing
- Fixes PGShield apps listing when using community apps, previously core apps would not be displayed.
- Removes watchtower from the core menu, use watchtower settings inside PG Settings to deploy.
- Minor GCE fixes

**New features**

- When deploying sonarr/radarr/lidarr an informational message will be displayed at the end of the deployment to notify users of important manual configuration needed for things to work correctly.
- Updates to PGUI to include used space
