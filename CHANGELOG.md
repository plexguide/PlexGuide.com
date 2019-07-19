# Changelog

All notable changes to the core project will be added to this repo. For changes to PGClone, see [PGClone Changelog](https://github.com/PGBlitz/PGClone/blob/v8.6/CHANGELOG.md).
## [8.6.10] - 2019-07-19

**New features**

- disable ansible deprecation warnings when updating ansible.

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
