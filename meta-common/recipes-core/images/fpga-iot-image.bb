DESCRIPTION = "Base FPGA IoT image, based on core-image."

IMAGE_FEATURES += " splash ssh-server-openssh "

IMAGE_INSTALL = " \
	packagegroup-core-boot \
	packagegroup-core-full-cmdline \
	${CORE_IMAGE_EXTRA_INSTALL} \
"

inherit core-image


IMAGE_INSTALL_append += " socat i2c-tools mtd-utils \
	bash coreutils util-linux devmem2 systemd dhcp-client \
"

IMAGE_FSTYPES += " jffs2 squashfs-xz"
