# Changelog

## 2016-09-21: 1.0.0

  - Template main config file
  - Fixed indentation for http_directives & https_directives
  - default access_log name typo fixed
  - Improved some tests

## 2016-03-31: 0.5.0

  - Porting functionality to comply with Ansible 2.x changes
    complex vars
    become in favor of sudo

## 2016-03-18: 0.4.0

  - Added usage Documentation
  - Remove default_server from default package configuration
  - Logdir can be present on a different filesystem in which case a symlink 
    will be created
  - Vhost access and error logs attributes can be defined to change the
    log path

