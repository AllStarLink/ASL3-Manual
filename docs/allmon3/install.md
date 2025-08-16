# Installation

## Supported Platforms
Allmon3 is only supported on:

* Debian 12 Bookworm (including Raspberry Pi OS 12)
* Debian 11 Bullseye (including Raspberry Pi OS 11)

Allmon3 is installed by default on the Raspberry Pi Image, no installation actions are required, you can proceed directly to [configuration](./config.md).

## ASL3 Packages Install

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

### Debian 11

* Enable the Debian 11 `bullseye-backports` package repository:

```
gpg --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
gpg --keyserver keyserver.ubuntu.com --recv-keys 6ED0E7B82643E131
gpg --export 0E98404D386FA1D9 | sudo apt-key add -
gpg --export 6ED0E7B82643E131 | sudo apt-key add -
echo "deb https://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/bullseye-backports.list
apt update
```

* Install the dependencies:

```
apt install -y apache2 python3-argon2 
apt install -y -t bullseye-backports python3-websockets python3-aiohttp python3-aiohttp-session
```

* Install Allmon3:

```
wget https://github.com/AllStarLink/Allmon3/releases/download/t_rel_1_2_0/allmon3_1.2.0-1.bullseye_all.deb
dpkg -i allmon3_1.2.0-1.bullseye_all.deb
```

### Debian 10
**NOTE:** Allmon v1.2.1 will be the last version for Debian 10. Please upgrade your AllStarLink system to ASL3 on Debian 12.

* Enable the Debian 10 `buster-backports` package repository:

```
gpg --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
gpg --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
gpg --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9
gpg --keyserver keyserver.ubuntu.com --recv-keys 6ED0E7B82643E131
gpg --export 04EE7237B7D453EC | sudo apt-key add -
gpg --export 648ACFD622F3D138 | sudo apt-key add -
gpg --export 0E98404D386FA1D9 | sudo apt-key add -
gpg --export 6ED0E7B82643E131 | sudo apt-key add -
echo "deb https://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list
apt update
```

* Install the dependencies:

```
apt install -y apache2 python3-argon2 
apt install -y -t buster-backports python3-async-timeout python3-attr python3-multidict python3-yarl python3-pip
```

* Install Python modules using `pip3`:

```
apt remove python3-aiohttp python3-websockets
pip3 install aiohttp
pip3 install aiohttp_session
pip3 install websockets
```

* Update the CA Certificate chain since Debian 10 is out of support:

```
apt install ca-certificates
update-ca-certificates --fresh
```

* Install Allmon3 (Debian 10 version):

```
wget https://github.com/AllStarLink/Allmon3/releases/download/t_rel_1_2_0/allmon3_1.2.0-1.buster_all.deb
dpkg -i allmon3_1.2.0-1.buster_all.debntu.com --recv-keys 6ED0E7B82643E131
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