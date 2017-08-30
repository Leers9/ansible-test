# Ansible role for Nginx

[![Build Status](https://travis-ci.org/torian/ansible-role-nginx.svg)](https://travis-ci.org/torian/ansible-role-nginx)

This Ansible role installs Nginx from the distribution's package repository 

## Supported Platforms

  * EL / Centos (6 / 7)
  * Debian (Wheezy / Jessie)
  * Ubuntu (Trusty)
  * AMZ Linux

## Role Variables

Here are some default vars which might be of interest to kickstart your
configuration. If you want a complete idea, take a look at `defaults/main.yml`.
```
nginx_config_dir: "{{nginx_prefix}}/conf.d"
nginx_ssl_dir:    "{{nginx_prefix}}/ssl"
nginx_log_dir:    "/var/log/nginx"
nginx_config:  {}
nginx_vhosts:  []
nginx_disable_vhosts: []
```

The following vars take care of the main nginx configuration file:

 * nginx_context_main
 * nginx_context_events
 * nginx_context_http

By default they are unset, and the `*_default` ones set some sane defaults.
An example of the defaults for those variables is:

```
nginx_context_main_default: |
  worker_rlimit_nofile 4096;
  worker_processes auto;

nginx_context_events_default: |
  worker_connections 768;
```

## Usage

The role give you enough flexibility to do what you want with nginx. Let's
start with vhosts:

### nginx_vhosts var

This one deserves it's own section, as it can turn into a rather large one.
For instance, `nginx_vhosts` is an array, that contains a dictionary with
variables that are only applied to this particular host.

Examples are very good. A very short one:
```
nginx_vhosts:
  - server_name: foo.com
    server_aliases:
      - bar.foo.com
      - foo.bar.baz
    root: /var/www/foo.com/html
```

If you want to enable SSL:
```
nginx_vhosts:
  - server_name: foo.com
    server_aliases:
      - bar.foo.com
      - foo.bar.baz
    root: /var/www/foo.com/html
    ssl_enabled: true
    certs:
      key:   "{{your_key}}"
      crt:   "{{your_certificate}}"
      ca:    "{{a_ca}}"
      chain: "{{optionally_a_chain}}"
```

So far so good, but, you might be wondering where is the rest of the
configuration that you require, and this is when the `http_directives`
and `https_directives` enter the game:
```
nginx_vhosts:
  - server_name: foo.com
    # ...
    http_directives: |
        
        location / {
          return 301 https://foo.com/
        }

    https_directives: |

        client_max_body_size 5m;

        gzip on;
        gzip_min_length  1100;
        gzip_buffers     4 8k;
        gzip_types       text/plain text/css;

        location / {
          proxy_pass http://some.other.place
        } 
```
We used the very helpfull multiline yaml metacharacter `|`.

By default, access and error logs, if not defined otherwise, are
put in `{{nginx_log_dir}}/{{vhost.server_name}}`. You can overwrite
this specifying the `access_log` and `error_log` attributes:
```
nginx_vhosts:
  - server_name: foo.com
    # ...
    access_log: /path/to/logdir/access.log
    error_log:  /path/to/logdir/error.log
```

Usually, a very important things is to define your default vhost:
```
nginx_vhosts:
  - server_name: foo.com
    default_server: true
```

Now, the role will not fail if you define two default vhosts, but you can 
guess that nginx will refuse to start.

Other optional attributes of a virtualhost can be:

```
log_fmt: myformat
```
When defined, this log format will be used for the access_log. You can use
it in conjunction with `nginx_config`.

```
root: /some/path/to/document/root
```
If defined, this will be the value for `root` :). If the directory
does not exists, and you want it created, you need to enable
`create_root` (per vhost).

```
create_root: false
```
If defined and set to true, this will create the root directory for
the vhost.

```
logrotate_enabled: true
```
Enabled by default. Will create a logrotate config file.

```
logrotate_directives: |
  create 0644 user group
  # ...
```
Define logrorate directives per virtualhost.


### nginx_config var

This variable is a dictionary, that contains nginx directives that
should be defined in the `server{}` section, and are to be loaded
via the inclusion of the `conf.d` directory.

Log formats need to be defined at the `server` scope, so this is
how you would do it:
```
nginx_config:
  log_format: |
    log_format myformat '$remote_addr - $remote_user [$time_local]'
      '"$request" $status "$http_referer" "$http_user_agent"';
```
This will create the file `{{nginx_config_dir}}/log_format.conf`,
along with the contents.

### Log directory

You might be in need to specify a different path or even filesystem
where to store your logs. The variable `nginx_symlink_src` comes to
the rescue, and helps you keep the well known default logdir as a symlink.

If defined to something other that `False`, the var represents the path
to the logdir. The role will create the directory if it does not exists, 
and symlink `{{nginx_log_dir}}` (`/var/log/nginx`).

If there are any previous contents on `{{nginx_log_dir}}`, the it will
be renamed to `{{nginx_log_dir}}.bkp`.

