# cFS running under the governance of RTEMS

cFS natively supports RTEMS, however depending on the versions (of cFS itself,
RTEMS and other tools) getting it to work might be tricky.  The point of this
repository is to establish a complete environment in which the cFS application
will build correctly.  This is based on two approaches - first are the git
submodules that gurantee the same versions of cFS apps and RTEMS components and
the second one is the NIX system, which provides the same build environment for
every build.

The same goal could be achieved using Docker or VirtualBox (possibly with
Vagrant), but none of those are really meant for building; these are tools to
*run* code in contenerized/virtualized environment.

## How to do the build

### Clone this repo
```
git clone https://github.com/boryszef/cfs-on-rtems.git
```

### Install NIX on your system

This depends mostly on the system, but on Debian `sudo apt-get install nix-bin`
should do the trick.

If you need to put the NIX store in a non-standard location, because (like in my
case) the space on your root partition is tight, the trick is to bind-mount that
location; symlink would not work. Here are the commands
```
mv /nix /somewhere/nix
mkdir /nix
mount --bind /somewhere/nix /nix
```
This is enough to trick NIX into thinking it has everything in the usual location.

### Run the build script

The script is meant to be self-contained and dependency-free, so just:
```
./build.sh
```