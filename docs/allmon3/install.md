# Installation

## Supported Platforms
Allmon3 is only supported on:

* Debian 13 Bookworm (including Raspberry Pi OS 13)
* Debian 12 Bookworm (including Raspberry Pi OS 12)


Allmon3 is installed by default on the Raspberry Pi Image, no installation actions are required, you can proceed directly to [configuration](./config.md).

## ASL3 Packages Install

### Debian 13

* Install the AllStarLink repository file:

```
sudo -s
cd /tmp
wget https://repo.allstarlink.org/public/asl-apt-repos.deb13_all.deb
sudo dpkg -i asl-apt-repos.deb13_all.deb
sudo apt update
```

* Install Allmon3:

```
sudo apt install allmon3
```

### Debian 12

* Install the AllStarLink repository file:

```
sudo -s
cd /tmp
wget https://repo.allstarlink.org/public/asl-apt-repos.deb12_all.deb
sudo dpkg -i asl-apt-repos.deb12_all.deb
sudo apt update
```

* Install Allmon3:

```
sudo apt install allmon3
```

## Using Nginx instead of Apache
Nginx can be used instead of Apache. Instead of using the `apache2` package, install `nginx` using the above directions. After configuring Nginx, edit `/etc/nginx/sites-available/default` (or your preferred site configuration) and add an `include` directive within the appropriate `server { }` configuration block. For example:

```
server {
    listen 80 default_server;

    [... other stuff ...]

    include /etc/allmon3/nginx.conf;

    [... other stuff ...]
}
```

## Install from Source
Installation from source is not supported in the general use case. However, `make install` should yield a working system. Source is available at [https://github.com/AllStarLink/Allmon3](https://github.com/AllStarLink/Allmon3)