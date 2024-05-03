# AllStarLink Apt Repos
AllStarLink's primary installation method is through the use of
Debian packages and the Apt deployment system.

## Repository Structure
The repository is located at `https://repo.allstarlink.org/public` and
is managed using [Aptly](https://www.aptly.info/). The Aptly structure
is a multi-local-repo system that is coalesced into a single 
public repository with multiple components per distribution.

There are three main local repositories:

* **asl3-prod** - Packages for production-quality use.

* **asl3-beta** - Packages that are ready for general testing and
are expected to be promoted to asl3-prod.

* **asl3-devel** - Development quality packages that are for
development testing only. While these packages are available
to the general user, use of this component in extremely
discouraged without a developer's guidance.

Each repository contains one or more distributions. Currently the
only distribution supported is `bookworm` for Debian 12.

Each repository has a default component name that, when
published together, form the basis of the labeling scheme of 
promotion of packages from devel -> beta -> prod. The component
mapping is:

* asl3-prod = main
* asl3-beta = beta
* asl3-devel = devel

All local repositories are merged and published into a single
public-facing repository. This is usable by one of the following
`.list` configurations in` /etc/apt/sources.list.d`:

```bash
# Primary AllStarLink Repo for Production Packages
deb [signed-by=/etc/apt/keyrings/allstarlink.gpg] https://repo.allstarlink.org/public bookworm main

# Include Beta Component for Testing
deb [signed-by=/etc/apt/keyrings/allstarlink.gpg]  https://repo.allstarlink.org/public bookworm main beta

# Include Beta and Devel component for Development
deb [signed-by=/etc/apt/keyrings/allstarlink.gpg]  https://repo.allstarlink.org/public bookworm main beta devel
```

All packages in the repository are signed by GPG and the key is provided with
repository installation .deb file.

## Aptly + GitHub Runner Integrations
ASL3-related GitHub repositories are integrated with the Aptly repository
and running the "Make and Publish Pkgs" Action from each project
will result in .deb files being compiled and stored in Aptly. Currently
it's possible to build files directly into the `devel` and `beta`
components but not prod. Moving packages into `prod` currently
requires administrator intervention. This will be changed at some future
date.

## Aptly CLI
It is possible to run Aptly commands from the shell on `repo.allstarlink.org`
in addition to using the web-based API.

### Setup
All commands to Aptly must be run as the `aptly` user. To do this,
each account on the repository server should be member of the `sudo`
and `aptly` UNIX groups.

Before issuing any Aptly commands run the following:
```bash
alias aptly="sudo -u aptly -- aptly"
```
to ensure that all commands are run as the `aptly` user.

### Adding a File to a Local Repo
Adding a file to the local repo is straight-forward:
```bash
aptly repo add REPO FILE-or-DIR
```

For example, to add the latest Allmon3 to the production
repository:
```bash
$ aptly repo add asl3-prod allmon3_1.2.1-2_all.deb
Loading packages...
[+] allmon3_1.2.1-2_all added
```

### Publishing Repositories
Coalescing and publishing the public repository with
all components is:
```bash
aptly publish update bookworm
```
Whe other distributions are supported, replace "bookworm"
with the appropriate distribution. Upon execution, a prompt
will appear for the GPG signing key for the repository. Provide it.

And example, successful publication looks like:
```bash
$ aptly publish update bookworm
Loading packages...
Generating metadata files and linking package files...
Finalizing metadata files...
Signing file 'Release' with gpg, please enter your passphrase when prompted:
Clearsigning file 'Release' with gpg, please enter your passphrase when prompted:
Cleaning up prefix "." components beta, devel, main...

Publish for local repo ./bookworm [all, amd64, arm64, armhf] publishes {beta: [asl3-beta]}, {devel: [asl3-devel]}, {main: [asl3-prod]} has been successfully updated.
```

### Promoting Packages to Prod
TODO