FILESEXTRAPATHS_prepend_mx6ul-comm-module := "${THISDIR}/commod-mx6ul:"

SRC_URI_append_mx6ul-comm-module = " 	\
    file://rauc_downgrade_barrier.sh 	\
    file://system.conf			\
    file://0001-changed-tar-flag-to-no-same-owner-creates-problems-w.patch \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"


# configure the downgrade barrier, here you could move back from a
# production system to a development mode by setting r0
DOWNGRADE_BARRIER_VERSION ?= "${RAUC_BUNDLE_VERSION}"

do_install_prepend_mx6ul-comm-module() {
	# check for default system.conf from meta-rauc
	shasum=$(sha256sum "${WORKDIR}/system.conf" | cut -d' ' -f1)
	if [ "$shasum" = "cb8c74d6fefea692c4284bb80ec24385c74f3c46a921b8f57334c7a5a3cf1312" ]; then
		bbnote "No project specific system.conf has been provided. We use the Phytec RDK specific config files."
		cp ${WORKDIR}/system.conf ${WORKDIR}/system.conf
	fi
	sed -i -e 's!@MACHINE@!${MACHINE}!g' ${WORKDIR}/system.conf

	echo "${DOWNGRADE_BARRIER_VERSION}" > ${WORKDIR}/downgrade_barrier_version
}

do_install_append_mx6ul-comm-module() {
	# check for problematic certificate setups
	shasum=$(sha256sum "${WORKDIR}/${RAUC_KEYRING_FILE}" | cut -d' ' -f1)
	if [ "$shasum" = "91efd86dfbffa360c909b06b54902348075c5ba7902ad1ec30d25527a1f8ca09" ]; then
		bbwarn "You're including Phytec's Development Keyring in the rauc bundle. Please create your own!"
	fi

	install -d ${D}${bindir}
	install -m 0774 ${WORKDIR}/update_usb.sh ${D}${bindir}
	install -m 0774 ${WORKDIR}/rauc_downgrade_barrier.sh ${D}${bindir}

	install -d ${D}${sysconfdir}/rauc
	install -m 0644 ${WORKDIR}/downgrade_barrier_version ${D}${sysconfdir}/rauc/downgrade_barrier_version

	rm -f ${D}${bindir}/update_usb.sh

	rm -f ${D}${systemd_unitdir}/system/update-usb@.service
	rm -f ${D}${nonarch_base_libdir}/udev/rules.d/10-update-usb.rules 
}

FILES_rauc-update-usb_remove += " \
    ${bindir}/update_usb.sh \
    ${systemd_unitdir}/system/update-usb@.service \
    ${base_libdir}/udev/rules.d/10-update-usb.rules \
"

SYSTEMD_PACKAGES_remove += "rauc-update-usb"
SYSTEMD_SERVICE_rauc-update-usb_remove = "update-usb@.service"
SYSTEMD_AUTO_ENABLE_rauc-update-usb_remove = "enable"

