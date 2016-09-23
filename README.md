##  CreatorDev OpenWrt CI Build system for build-all

To host all the possible packages built for pistachio target, we need this build-all CI system.So that one can install the required package on the Ci40 without building it manually.

### Steps for triggering build-all release of CreatorDev/Openwrt are as follows :-

Create a directory to clone this CI repository which has openwrt as submodule :-

    $ mkdir openwrt-ci
    $ cd openwrt-ci
    $ git clone https://github.com/Creatordev/ci.git --recursive

## To build openwrt with all userspace and kernelspace packages:

For CA8210:

    $ make openwrt P=creator-platform-all-cascoda.config V=s

For CC2520:

    $ make openwrt P=creator-platform-all.config V=s

## To build specific tag release of openwrt with all userspace and kernelspace packages:

    $ make openwrt T=<tag_version> P=creator-platform-all-cascoda.config V=s

e.g.

    $ make openwrt T=0.9.6 P=creator-platform-all-cascoda.config V=s
