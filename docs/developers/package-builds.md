# Building ASL3-Asterisk

## Building .deb Files
These directions outline how to create the `.deb` files via GitHub using the Action workflows and the ASL custom runner AMIs in AWS.

Kicking off the build processes requires knowledge of all of the topics below before starting it.

## Package version format
All packages created by this repo have the following version format based on `deb-version(7)` manpage explanation.

```
 ${EPOCH}:${ASTERISK_VERSION}+asl3-${RPT_VERSION}-${PACKAGE_VERSION}

|----+---|--------+--------------------------X-----+--------X
     |            |                                |
     |            +-- "upstream-version"           |
     |                                             |
     +-- "epoch"               "debian-revision" --+
```

The values are defined as follows:

* `EPOCH` - By Debian Asterisk convention this is hardcoded as "2"

* `ASTERISK_VERSION` - The Asterisk LTS version to use for these packages - e.g. 20.8.1

* `RPT_VERSION` - The `app_rpt` version to use for these packages. This should be based on the tag of the release of app_rpt applied to that repository that is driven  by the major, minor, and patch versions listed in `app_rpt.h`

* `PACKAGE_VERSION` - The ASL3 project release version of the package build. Usually "1" unless there was a problem specifically with package building that caused a new .deb publication needed. In general, this is only incremented if `ASTERISK_VERSION` and `RPT_VERSION` aren't changing but something needed to be changed in the `debian/` build directory

A file generated from this repo using the versioning format above will be named, for example `asl3-asterisk-20.8.1+asl3-3.0.0-1`. Note that the *epoch* does not appear in the filename by Debian convention.

## Determining Asterisk Version
Currently, this is structured to be built against Asterisk 20 Long Term Servicing (LTS). Do not use any version of Asterisk that is not the latest version of Asterisk 20 LTS.

The version is listed at [Download Asterisk](https://www.asterisk.org/downloads/). The version of Asterisk entered in the Actions launcher will cause the proper version of Asterisk 20 LTS to be downloaded and folded into the builder.

## Locking In and Determining the app\_rpt Version
When a build of `.deb` files is initiated, the `app_rpt` repo must be tagged prior to initiating the build process. The tag version should be in the format `MAJOR.MINOR.PATCH` as found in `app_rpt.h`.

## Determining the Package Version
This should be a monotonically increasing integer starting with "1", reflecting a change in Asterisk Version + `app_rpt`. For example, if building Asterisk 20.8.1 with `app_rpt v3.0.0`, then the first build of a package should be "1", the second "2", and so on.

However, if from the above example, `app_rpt` is now v3.1.0 or Asterisk becomes 20.9.0 then the package version should reset back to "1" and start over.

## Create a GitHub Release
Create a [Release](https://github.com/AllStarLink/asl3-asterisk/releases) to store the `.deb` files in. The name of the release should follow the format:

```
ASTERISK_VERSION_asl3-RPT_VERSION-PACKAGE_VERSION
```

For the above example of Asterisk "20.7.0", `app_rpt` "1.2", and package version "1" the release tag and name would be:

```
20.7.0_asl3-1.2-1
```

**NOTE:** GitHub acts oddly about + signs in the tags and release names so it's converted to an underscore.

## Executing the GitHub Action to Build Packages
The following steps build the Debian packages:

* Navigate to the [GitHub repository Actions tab](https://github.com/AllStarLink/asl3-asterisk/actions)

* Under *All workflows* -> *Workflows* click on `Make and Publish Pkgs`

* To the right of the label *This workflow has a workflow_dispatch event trigger* click on **Run workflow**

* In the dropdown, enter the following information:

    * *Asterisk LTS Version Base* - This is the Asterisk version determined above

    * *`app_rpt` Version Tag* - This is the `app_rpt` version determined above

    * *Package Revision* - This is the Package Version determined above

    * *Platform Architecture* - Choose `amd64` or `arm64` as appropriate

    * *Debian Release Version* - Choose the Debian release version to build. Note that currently the releases in GitHub do not support multiple Debian releases in the same GitHub release. This is a ToDo item (#17)

    * *Github Release Tag* - This is tag release created above in Create a GitHub Release

    * For now, leave *Aptly Repository Stream* and *Commit Versioning* at their default values

* Click **Run Workflow**

* After a moment, a new running workflow will appear (yellow circle with a darker circling swoosh). This can be monitored for process. If the process succeeds with a green checkbox, the `.deb` files should appear in the Release. If not, there are problems that need to be diagnosed and resolved.

**NOTE:** As noted above, you will choose the platform architecture when starting a workflow. All workflows will create the architecture specific packages. The `amd64` workflow also creates the architecture independent (`all`) packages.  What does this mean?  If you only want `amd64` packages then you would only need to run the single workflow. But, if you want packages for an alternate architecture (e.g. `arm64`) then will need to run a workflow for that architecture AND one for the `amd64` architecture.
