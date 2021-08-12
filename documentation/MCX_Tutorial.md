# MCX Tutorial

## Overview

Getting started with simulating light propagation using software developed by Prof. Q. Fang's team is not easy. There are several variants of the software, the differences of which are not immediately obvious, especially for a beginner. MCX's website has a modern layout, but unfortunately this does not make the content easy to find. For example, there are several menus that can be found in different places on the screen but are not recognizable as a menu at first glance (e.g. the menu line transitions between different background colors that are supposed to represent different pages).

### MCX

Supports CUDA enabled Nvidia grafic cards. Best with dedicated CUDA GPU which is not used for displaying grafics on a monitor. It seems to be the most used and fastetst simulation of the whole project. 


### MCXLAB 

The functionality of the standalone program MCX is provided as mex file for Matlab or Octave. This version should be preferentially interesting for users who already work with Matlab/Octave. Many of the examples provided in the git repositories of Prof. Fang use this Matlab syntax. Displaying/Plotting the generated data is more easy in the Matlab environment because there are many prebuilt functions. The support for Octave is not as good as for Matlab, i.e. some functions are missing and some are slower and just a few operating systems are supported.

### MMC

See more details here: [https://github.com/fangq/mmc](https://github.com/fangq/mmc) or [MMC on mcx.space](http://mcx.space/wiki/index.cgi?MMC)

mmc is a Monte Carlo simulation software that is mesh-based. Mesh-based simply means that a complex geometry is described by triangles and tetrahedral elements as usual in finite element simulations. This is said to provide particularly good results when high accuracy is required in the geometry of the simulation, as is the case in medicine, for example. The existence of MMC implicitly assumes that there is another way of describing geometry using voxels. These have disadvantages where the geometry is not bounded along one of the axes in the x, y or z direction ("oblique" surfaces). 

Since the Version v2020 MMC also supports [GPU acceleration with OpenCL](http://mcx.space/wiki/index.cgi?MMC/Doc/ReleaseNotes/v2020). But with the exact nomenclature it would then be called MMCL or MMCLABCL.

### MMCLAB

MMCLAB is the Matlab/Octave version of MMC.

### MCXCL

This is a version of the MCX software which does not require a CUDA enabled GPU. It is based on OpenCL which means that it can run CPU based or with non-Nvidia GPUs. See details here [https://github.com/fangq/mcxcl](https://github.com/fangq/mcxcl#requirement-and-installation)
 
### MCXStudio 

Cross-platform graphical user interface for the stand-alone programs MCX, MMC and MCXCL

### MCX Cloud

MCX Cloud is a free cloud-computing service provided by Prof. Fangs group to run MCX simulations without requiring users to install their own GPUs.

### Other Utils

Prof. Fang also provides other helpful tools like [zmat](https://github.com/fangq/zmat), [jdata](https://github.com/fangq/jdata), [iso2mesh](https://github.com/fangq/iso2mesh) and others which are partly also used directly by the MCX-Suite.


## Needed software

First of all you will need the MCX Suite. Get the latest nightly build from [here](http://mcx.space/nightly/) and extract it on a location of your choice. Or on Windows execute the installer.

There are multiple ways to input data into MCX and interpret the output.

The most convenient way is MCXLAB. The MCX integration into Matlab/Octave.
If one has access to a MATLAB Licence both Windows and Linux should work just fine.

Without it one has to use GNU Octave. The support for using mcxlab-octave is limited. [Windows](https://groups.google.com/g/mcx-users/c/ePYOykhcoao) probably just doesn't work (yet).
Ubuntu 20.04 doesn't work. TODO list errors, and write bug reports
[Ubuntu 18.04](https://launchpad.net/~fangq/+archive/ubuntu/ppa) works and [Fedora 34](https://groups.google.com/g/mcx-users/c/5_YZxB6UYAw/m/7dNQnV_kAQAJ) most probably also works (only tested partially in a VM)

Installation steps for Ubuntu 18.04:
```
sudo apt update
sudo apt upgrade
# also make sure that a current nvidia driver is installed.
```

```
sudo add-apt-repository ppa:fangq/ppa
sudo apt-get update
sudo apt install octave
sudo apt install octave-*
```

## Data preparation

