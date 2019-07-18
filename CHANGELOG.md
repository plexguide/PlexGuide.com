# Changelog

All notable changes to the core project will be added to this repo. For changes to PGClone, see [PGClone Changelog](https://github.com/PGBlitz/PGClone/blob/v8.6/CHANGELOG.md).

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
