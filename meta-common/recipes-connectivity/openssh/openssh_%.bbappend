FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


do_install_append () {
# Enable root logging
	sed -i -e 's:#PermitRootLogin prohibit-password:PermitRootLogin yes:' ${D}${sysconfdir}/ssh/sshd_config
}

