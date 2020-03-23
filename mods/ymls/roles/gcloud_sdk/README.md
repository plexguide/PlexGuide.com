[![Build Status](https://travis-ci.org/wtanaka/ansible-role-gcloud-sdk.svg?branch=master)](https://travis-ci.org/wtanaka/ansible-role-gcloud-sdk)
[![CircleCI](https://circleci.com/gh/wtanaka/ansible-role-gcloud-sdk.svg?style=svg)](https://circleci.com/gh/wtanaka/ansible-role-gcloud-sdk)

wtanaka.gcloud-sdk
==================

Ansible role to install Google Cloud SDK

Example Playbook
----------------

    - hosts: all
      roles:
         - role: wtanaka.gcloud-sdk

Variables
---------

The full set of configuration options available are visible in
[defaults/main.yml](defaults/main.yml)

### `gcloud_sdk_additional_package_names`

Default: `[]`

list of package name strings to additionally install.  Available examples:

* `google-cloud-sdk-app-engine-python`
* `google-cloud-sdk-app-engine-java`
* `google-cloud-sdk-datastore-emulator`
* `google-cloud-sdk-pubsub-emulator`
* `google-cloud-sdk-bigtable-emulator`
* `kubectl`

License
-------

GPLv2

Author Information
------------------

http://wtanaka.com/
