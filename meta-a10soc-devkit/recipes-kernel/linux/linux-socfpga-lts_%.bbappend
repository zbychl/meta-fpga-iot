COMPATIBLE_MACHINE_${MACHINE} = "a10soc-devkit"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


SRC_URI += "file://a10soc-devkit.dts;subdir=git/arch/arm/boot/dts \
"

# Add Kernel config with required configuration about features disabling or enabling
# SRC_URI += "file://test.cfg "
