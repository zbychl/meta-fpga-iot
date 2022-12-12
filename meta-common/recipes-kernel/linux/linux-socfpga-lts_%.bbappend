COMPATIBLE_MACHINE_${MACHINE} = "de0-nano"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Control support for 1-Wire Temperature Sensors
SRC_URI += "file://1wire-thermal-sensor.cfg "
