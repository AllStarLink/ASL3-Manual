# Building ASL3-Asterisk

## Building .deb Files
These directions outline how to create the `.deb` files
via GitHub using the Action workflows and the ASL custom
runner AMIs in AWS.

Kicking off the build processes requires knowledge of all
of the topics below before starting it.

## Package version format
All packages created by this repo have the following version
format based on `deb-version(7)` manpage explanation.

<pre>
 ${EPOCH}:${ASTERISK_VERSION}+asl3-${RPT_VERSION}-${PACKAGE_VERSION}

|----+---|--------+--------------------------X-----+--------X
     |            |                                |
     |            +-- "upstream-version"           |
     |                                             |
     +-- "epoch"               "debian-revision" --+
</pre>

The values are defined as follows:

* `EPOCH` - By Debian Asterisk convention this is hardcoded as "2"

* `ASTERISK_VERSION` - The Asterisk LTS version to use for these packages - e.g. 20.7.0

* `RPT_VERSION` - The "app\_rpt" version to use for these packages - e.g. 1.2

* `PACKAGE_VERSION` - The ASL3 project release version of the package build. Usually 1 unless there
was a problem specifically with package building that caused a new .deb publication needed. In
general, this is only incremented if `ASTERISK_VERSION` and `RPT_VERSION` aren't changing but
something needed to be changed in the `debian/` build directory.

A file generated from this repo using the versioning format above will be named,
for example `asl3-asterisk-20.7.0+asl3-1.2-1`. Note that the *epoch* does not appear
in the filename by debian convention.

## Determining Asterisk Version
Currently, this is structured to be built against Asterisk 20 Long Term Servicing
(LTS). Do not use any version of Asterisk that is not the latest version of 
Asterisk 20 LTS. The version is listed at
[Download Asterisk](https://www.asterisk.org/downloads/). The version of Asterisk
entered in the Actions launcher will cause the proper version of Asterisk 20 LTS
to be downloaded and folded into the builder.

## Locking In and Determining the app\_rpt Version
When a build of `.deb` files is initiated, the app\_rpt repo should be
tagged with a regular tag (not a lightweight tag) and the tag commit
comment should be it is for a debian build run.

The version of the tag should follow the reasonable progression of ASL3
development. For example the pre-Dahdi-removal and early beta testing
will definitely fall into the 1.x series. After Dahdi is removed,
the version will be incremented to 2.x. The value for "x" is simply
monotonically increasing from 0. It would also be possible to create
a major.minor.tertiary version structure in an 1.x.y format. What is
important for the building of the packages is a) the app\_rpt
repository is tagged with the release number to tie the repository and
the packages together and b) the new number supersedes the last version
as described in `man 7 deb-version`. For example:

```
1.0 < 1.1 < 1.1.1 < 1.2 < 2.0
```

To add a tag to the repository you will checkout the appropriate sources and use commands like :

```bash
git tag -a "1.2" -m "Tag for release 20.7.0_asl3-1.2-1"
git push --tags
```

## Determining the Package Version
This should be a monotonically increasing integer starting with 1
reflecting a change in Asterisk Version + app\_rpt. For example,
if building Asterisk 20.7.0 with app\_rpt v1.1, then
the first build of a package should be 1, the second 2, and so on.

However, if from the above example, app\_rpt is now v1.2
then the package version should reset back to 1 and start over. The same
if the version of Asterisk changes but not app\_rpt. Or also
obviously if both change.

## Create a GitHub Release
Create a [Release](https://github.com/AllStarLink/asl3-asterisk/releases)
to store the .deb files in. The name of the release should follow the 
format:

```
ASTERISK_VERSION_asl3-RPT_VERSION-PACKAGE_VERSION
```

For the above example of Asterisk "20.7.0", app\_rpt "1.2", and 
package version "1" the release tag and name would be:
```
20.7.0_asl3-1.2-1
```
Note: GitHub acts oddly about + signs in the tags and release
names so it's converted to an underscore.


## Executing the GitHub Action to Build Packages
The following steps build the Debian packages:

* Navigate to the [GitHub repository Actions tab](https://github.com/AllStarLink/asl3-asterisk/actions)

* Under *All workflows* -> *Workflows* click on `Make and Publish Pkgs`

* To the right of the label *This workflow has a workflow_dispatch event trigger*
click on **Run workflow**

* In the dropdown, enter the following information:

    * *Asterisk LTS Version Base* - This is the Asterisk version determined above

    * *app\_rpt Version Tag* - This is the app\_rpt version determined above

    * *Package Revision* - This is the Package Version determined above

    * *Platform Architecture* - Choose `amd64` or `arm64` as appropriate

    * *Debian Release Version* - Choose the Debian release version to build. Note that
      currently the releases in GitHub do not support multiple Debian releases in the
      same GitHub release. This is a ToDo item (#17).

    * *Github Release Tag* - This is tag release created above in Create a GitHub Release

    * For now, leave *Aptly Repository Stream* and *Commit Versioning* at their
    default values.

* Click **Run Workflow**

* After a moment, a new running workflow will appear (yellow circle with a darker
circling swoosh). This can be monitored for process. If the process succeeds with
a green checkbox, the .deb files should appear in the Release. If not,
there are problems that need to be diagnosed and resolved.

Note: as noted above, you will choose the platform architecture when starting a workflow.  All workflows will create the architecture specific packages.  The "amd64" workflow also creates the architecture independent ("all") packages.  What does this mean?  If you only want "amd64" packages then you would only need to run the single workflow.  But, if you want packages for an alternate architecture (e.g. "arm64") then will need to run a workflow for that architecture AND one for the "amd64" architecture.
