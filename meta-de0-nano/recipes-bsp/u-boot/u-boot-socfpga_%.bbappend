FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://bootcmd.cfg \
"

PROVIDES += "u-boot"
