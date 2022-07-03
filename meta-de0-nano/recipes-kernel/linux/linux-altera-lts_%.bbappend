COMPATIBLE_MACHINE_${MACHINE} = "de0-nano"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


SRC_URI += "file://de0-nano.dts;subdir=git/arch/arm/boot/dts \
"

