# Repository for Linux stuff in context of FPGA IOT


## Directory structure

```
.
|-- conf - Yocto build configuration files directory
|-- meta-de0-nano - De0 nano SoC Kit platform specific recipes
|-- meta-common - common recpies
|-- sources - ...
```

## Enviroment
* Ubuntu 22.04 LTS
* Installed packages according to the https://www.yoctoproject.org/docs/3.0/brief-yoctoprojectqs/brief-yoctoprojectqs.html
* ~15GB free room on the storage
* Ethernet connection available and access to public WWW. It may requires setting up proxy.

Example for packages installation:

```
sudo apt update
sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential \
             chrpath socat libsdl1.2-dev xterm libncurses5-dev lib32stdc++6 libtool autoconf \
             npm zstd python u-boot-tools

```

## Yocto building (Kernel, DTS, RootFS)
Yocto building procedure is based on the one from https://rocketboards.org/foswiki/Documentation/YoctoDoraBuildWithMetaAltera
Custom layer was added to bring image features flexibility, e.g. adding/removing RootFS contatin, DTS modification depends on platform, etc.

Yocto manual: https://docs.yoctoproject.org/

### Steps
In further documentation path to the build root directory will be called as [BUILDROOT]
* Create directory, e.g. mkdir linux, enter the directory
* Clone poky: git clone -b dunfell https://git.yoctoproject.org/git/poky, SHA: eb8e26214e1833d1bcc2223258e9e1ac121cb1f3
* Clone meta-altera: git clone -b dunfell https://github.com/kraj/meta-altera.git, SHA: 237cd5ecd28491dbcff16d8d64662d3b56ac30df
* Clone meta-openembedded: git clone -b dunfell https://github.com/openembedded/meta-openembedded.git, SHA: 7203130ed8b58c0df75cb72222ac2bcf546bce44
* Clone this repo: git clone -b main https://github.com/zbychl/meta-fpga-iot.git
* Call 'export TEMPLATECONF=../meta-fpga-iot/meta-de0-nano/conf/'
* Call 'source poky/oe-init-build-env [BUILDROOT]' - [BUILDROOT] path can be omitted, 'build' directory will be just created
* Call 'bitbake fpga-iot-image', to speed up rebuild even after removing build directory shared Downloads and SState directory may be used. To do that please preapre yocto-local.conf file with the DL_DIR and SSTATE_DIR variables set to the new Download and SState directories locations. Then call bitake with -r switch available, e.g.: 'bitbake -r [some path]/yocto-local.conf fpga-iot-image', e.g.:
DL_DIR="path.../yocto-downloads"
SSTATE_DIR="path.../fpga-iot-yocto-sstate-cache"

### Artifacts
* kernel: [BUILDROOT]/tmp/deploy/images/de0-nano/zImage-de0-nano.bin
* dtb: [BUILDROOT]/tmp/deploy/images/de0-nano/de0-nano.dtb
* u-boot: [BUILDROOT]/tmp/deploy/images/de0-nano/u-boot-with-spl.sfp
* rootfs: [BUILDROOT]/tmp/deploy/images/de0-nano/fpga-iot-image-de0-nano.[ext,jffs2,...]
* SDMMC image: [BUILDROOT]/tmp/deploy/images/de0-nano/fpga-iot-image-de0-nano.wic

FPGA image shall be also added to SDMMC. It will be loaded automatically during boot. FPGA image shall be called 'de0-nano.rbf'.</br>
To convert .SOF to .RBF: quartus_cpf -o bitstream_compression=on -c bitstream.sof bitstream.rbf

## Updating image on SDMMC
### Under Linux (with SDMMC mounted)
* copy .wic image to sdmmc: sudo dd if=image.wic of=/dev/sdX bs=1M iflag=fullblock oflag=direct conv=fsync

### Under Windows (with SDMMC mounted)
* copy .wic image to sdmmc: use Win32DiskImage or any other available tool

### Under U-Boot:
* download .wic image to RAM using TFTP using 'tftp'(set up mac address, ip address, tftp server ip address) or 'dhcp'(set up mac address, tftp server ip address) commands
* write .wic image from RAM to SDMMC: mmc write $loadaddr 0x0 [size of .wic image in blocks], block is 512 bytes size

### Under Linux:
Some parts (kernel, dtb, fpga) can be also updated under Linux. The following steps shall be taken:

* mkdir /mnt/boot
* mount /dev/mmcblk0p1 /mnt/boot/

Under /mnt/boot the following images shall be available:

* zImage - Kernel
* de0-nano.dtb - Device Tree
* de0-nano.rbf - FPGA Bitstream

It is enought to copy new images there and reboot the system

## Network
### MAC address
De0 nano board does not have any EEPROM or ther non-volatile memory except SDMMC. Thius after each SDMMC re-flash need to provision MAC address. To do that please run the follo
wing command in U-Boot console (replace example MAC address with the right one):

```
setenv ethaddr 66:55:44:33:22:11
saveenv
reset
```

In case 'ethaddr' avariable is already available and it not possible to override it, please run the following command to bring back enviroment to default state.

```
env default -a -f
```

MAC address could be also changed in runtime under Linux. Please be aware that this setting is volatile.

```
# Change MAC address
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 66:55:44:33:22:11
sudo ip link set dev eth0 up
```

To set up non-volatile cofiguration please edit "/etc/systemd/network/00-fpga-iot-eth0.network" file.
To set up MAC address please add "[Link]" section and MACAddress variable under it (https://wiki.archlinux.org/index.php/MAC_address_spoofing#systemd-networkd), e.g.:

```
[Link]
MACAddress=66:55:44:33:22:11
```

This method has precedence over setting MAC address via U-Boot enviroment variable.

### IP address
IP address could be changed in runtime under Linux. Please be aware that this setting is volatile.

```
# Change IP address
sudo ip addr add 192.168.1.2 dev eth0
```

To set up non-volatile cofiguration for both IP please edit "/etc/systemd/network/00-fpga-iot-eth0.network" file.
To set up IP please under "[Network]" section comment DHCP variable and add Address and Gateway variables (https://wiki.archlinux.org/index.php/Systemd-networkd#Wired_adapter_u
sing_a_static_IP), e.g.:

```
[Network]
#DHCP=ipv4
LinkLocalAddressing=no
Address=192.168.1.2
Gateway=192.168.1.1
```

## Linux
### Credentials

* user: root
* pass: fpgai0t
