FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

SRC_URI += "file://00-fpga-iot-eth0.network"

FILES_${PN} += "${systemd_unitdir}/network/00-fpga-iot-eth0.network"

do_install_append() {
        install -m 644 ${WORKDIR}/00-fpga-iot-eth0.network ${D}${sysconfdir}/systemd/network/
}

