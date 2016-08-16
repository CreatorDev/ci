##  CreatorDev OpenWrt CI Build system for build-all

Creator-Kit requires multiple repositories for building, which are scattered across two GitHub organizations namely CreatorKit, Creatordev, FlowM2M and Cascoda.

### Steps for triggering build-all release of CreatorDev/Openwrt are as follows :-

Create a directory to clone this CI repository which has openwrt has submodule :-

    $ mkdir openwrt-ci
    $ cd openwrt-ci
    $ git clone https://github.com/Creatordev/ci.git --recursive

## To build openwrt with all userspace and kernelspace packages:

For CA8210:

    $ make openwrt P=creator-platform-all-cascoda.config V=s

For CC2520:

    $ make openwrt P=creator-platform-all.config V=s

