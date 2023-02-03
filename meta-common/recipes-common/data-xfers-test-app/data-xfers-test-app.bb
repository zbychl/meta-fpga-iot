SUMMARY = "Test application to demonstrate data transfers"

SRC_URI = "git://github.com/zbychl/data-xfers-test-app.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"
PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=43fda83878573685622d1a78886759ca"

S = "${WORKDIR}/git"

inherit cmake
