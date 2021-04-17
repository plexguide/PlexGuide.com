# ansible-rclone

[![Build Status](https://travis-ci.org/stefangweichinger/ansible-rclone.svg?branch=master)](https://travis-ci.org/stefangweichinger/ansible-rclone)

[![GitHub Open Issues](https://img.shields.io/github/issues/stefangweichinger/ansible-rclone.svg)](https://github.com/stefangweichinger/ansible-rclone/issues)
[![GitHub Stars](https://img.shields.io/github/stars/stefangweichinger/ansible-rclone.svg)](https://github.com/stefangweichinger/ansible-rclone)
[![GitHub Forks](https://img.shields.io/github/forks/stefangweichinger/ansible-rclone.svg)](https://github.com/stefangweichinger/ansible-rclone)

[![Ansible Role](https://img.shields.io/ansible/role/15522.svg)](https://galaxy.ansible.com/stefangweichinger/rclone)
[![Ansible Role Downloads](https://img.shields.io/ansible/role/d/15522.svg)](https://galaxy.ansible.com/stefangweichinger/rclone)


ansible role to install [rclone](https://github.com/ncw/rclone)

## Usage

1. Clone this repo into your local roles-directory or install via `ansible-galaxy install stefangweichinger.rclone`.
2. Add role to the hosts you want rclone installed to.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    install_manpages: "true"

This can be used to toggle the installation of manpages.

    rclone_arch: "amd64"

This variable chooses the target architecture (for example 'amd64').

    rclone_version: ""

The version of rclone to install. `rclone_version` is no longer set as a default, but if provided as a variable, can be set to a specific version number or "beta" to install the latest beta version.

## Dependencies

None.

## Example Playbook

    - hosts: rclone-hosts
      roles:
        - rclone

## Tests

New tests using [molecule](https://molecule.readthedocs.io/en/latest/index.html)

pls feel free to review my first steps into testing the role with molecule
additional distros might be added/tested soon

Currently there are two scenarios defined for running [molecule](https://molecule.readthedocs.io/en/latest/index.html):

* default:    runs tests over all defined distros at once, I use this for a local and overall test
* travis:     this one runs one travis-test-job per distro and is called via .travis.yml
    
