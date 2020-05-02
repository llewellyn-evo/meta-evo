SUMMARY = "Evologics Communication Module update bundle"
HOMEPAGE = "www.evologics.de"

inherit bundle

RAUC_BUNDLE_DESCRIPTION ?= "Evologics RAUC bundle ${DISTRO_VERSION}"

RAUC_BUNDLE_COMPATIBLE ?= "${MACHINE}"

RAUC_BUNDLE_SLOTS ?= "rootfs kernel"

RAUC_SLOT_rootfs[type] ?= "image"
RAUC_SLOT_rootfs[fstype] ?= "ext4"


RAUC_SLOT_kernel ?= "comm-module-bundle-tar"
RAUC_SLOT_kernel[type] ?= "file"
RAUC_SLOT_kernel[file] ?= "kernel-bundle.tar.xz"
RAUC_SLOT_kernel[fstype] ?= "vfat"

RAUC_KEY_FILE ?= "${CERT_PATH}/dev/private/development-1.key.pem"
RAUC_CERT_FILE ?= "${CERT_PATH}/dev/development-1.cert.pem"
