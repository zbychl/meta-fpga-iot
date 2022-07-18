SUMMARY = "Test application"

SRC_URI = "git://git@github.com/zbychl/test-app.git;protocol=ssh;branch=main"
SRCREV = "${AUTOREV}"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=43fda83878573685622d1a78886759ca"

S = "${WORKDIR}/git"

# Enable when used for service
#SRC_URI += "file://test-app.service "
#SYSTEMD_SERVICE:${PN} += "test-app.service"
#DEPENDS = "systemd "
#do_install_append () {
#    install -d ${D}${systemd_system_unitdir}
#    install -m 0644 ${WORKDIR}/test-app.service ${D}${systemd_system_unitdir}
#}

inherit cmake

# Enable when used for service
#inherit systemd
