# MCX Tutorial
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
Install the required software for mcxlab
```
sudo add-apt-repository ppa:fangq/ppa
sudo apt-get update
sudo apt install octave
sudo apt install octave-*
```
Install git
```
sudo apt install git
```
Clone the Repository
```
git clone https://r-n-d.informatik.hs-augsburg.de:8080/josefpro/nir-simulation.git
```

octave:
configure window arrangement 
be aware that file browser = workspace

## Data preparation

