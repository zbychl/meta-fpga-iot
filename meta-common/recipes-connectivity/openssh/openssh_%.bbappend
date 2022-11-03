FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


do_install:append () {
# Enable root logging
	sed -i -e 's:#PermitRootLogin prohibit-password:PermitRootLogin yes:' ${D}${sysconfdir}/ssh/sshd_config
}

