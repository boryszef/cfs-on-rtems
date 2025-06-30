# cFS running under the governance of RTEMS

cFS natively supports RTEMS, however depending on the versions (of cFS itself,
RTEMS and other tools) getting it to work might be tricky.  The point of this
repository is to establish a complete environment in which the cFS application
will build correctly.  This is based on two approaches - first are the git
submodules that gurantee the same versions of cFS apps and RTEMS components and
the second one is the NIX system, which provides the same build environment for
every build.

## How to do the build

1. Clone this repo
2. Install NIX on your system
3. git submodule update --init --recursive
4. Run the script (./build.sh)