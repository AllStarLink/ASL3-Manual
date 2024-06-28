# Miscellaneous
The following are miscellaneous advanced topics.

## asl-repo-switch Command
The `asl-repo-switch` command changes the system's package stream
for AllStarLink between three possibilities:

* **prod** - Packages for production-quality use.

* **beta** - Packages that are ready for general testing and
are expected to be promoted to prod.

* **devel** - Development quality packages that are for
development testing only. While these packages are available
to the general user, use of this component in extremely
discouraged without a developer's guidance.

In general, all ASL systems should run the `prod` stream.
People wanting to test forthcoming features and changes
should run the `beta` stream with the understanding there
is the possibility for some problems and bugs.

Changing package streams is accomplished with `asl-repo-switch -l STREAM`.
For example: `asl-repo-switch -l beta`. Note that packages 
will not be reverted to older versions if one moves
from beta back to prod.