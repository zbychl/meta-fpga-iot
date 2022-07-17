COMPATIBLE_MACHINE_${MACHINE} = "de0-nano"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


SRC_URI += "file://de0-nano.dts;subdir=git/arch/arm/boot/dts \
"

# Add Kernel config with required configuration about features disabling or enabling
# SRC_URI += "file://test.cfg "
