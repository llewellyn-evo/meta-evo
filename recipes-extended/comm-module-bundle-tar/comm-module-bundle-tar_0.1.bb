DESCRIPTION = "Recipe to create tar bundle for kernel and devicetree for rauc"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

DEPLOY_FOLDER = "${DEPLOY_DIR}/images/${MACHINE}/"
FOLDER_NAME = "kernel-bundle${IMAGE_VERSION_SUFFIX}"
TAR_FILE = "${DEPLOY_DIR}/images/${MACHINE}/kernel-bundle"


do_deploy(){
	install -d "${DEPLOY_FOLDER}${FOLDER_NAME}"
	cp "${DEPLOY_FOLDER}${@first_dtb(d)}" "${DEPLOY_FOLDER}${FOLDER_NAME}"
	cp "${DEPLOY_FOLDER}${@first_dtb(d)}" "${DEPLOY_FOLDER}${FOLDER_NAME}/oftree"
	cp "${DEPLOY_FOLDER}${KERNEL_IMAGETYPE}" "${DEPLOY_FOLDER}${FOLDER_NAME}/${KERNEL_IMAGETYPE}"
	tar -C "${DEPLOY_FOLDER}${FOLDER_NAME}" -cjf "${TAR_FILE}.tar.xz" .
}


def first_dtb(d):
    dtbs = d.getVar('KERNEL_DEVICETREE')
    print(dtbs)
    return dtbs.split()[0]

addtask do_deploy