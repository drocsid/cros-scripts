#!/bin/bash
# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Various upstart init script checks.

DOC_RESOURCE_URL="https://dev.chromium.org/chromium-os/chromiumos-design-docs/boot-design#TOC-Runtime-Resource-Limits"

# Default portage vars to make shellcheck happy.
: "${CATEGORY:=}"
: "${D:=}"
: "${PN:=}"

# Allow existing packages w/out oom to pass for now.
# NB: DO NOT ADD ANY NEW ENTRIES HERE.
known_bad_oom() {
  case "${CATEGORY}/${PN}" in
  app-accessibility/brltty|\
  app-accessibility/googletts|\
  app-benchmarks/bootchart|\
  app-crypt/trousers|\
  chromeos-base/actions|\
  chromeos-base/ap-daemons|\
  chromeos-base/ap-infra|\
  chromeos-base/ap-net|\
  chromeos-base/ap-scm|\
  chromeos-base/ap-security|\
  chromeos-base/ap-wireless|\
  chromeos-base/arc-adbd|\
  chromeos-base/arc-apk-cache|\
  chromeos-base/arc-appfuse|\
  chromeos-base/arc-base|\
  chromeos-base/arc-common-scripts|\
  chromeos-base/arc-myfiles|\
  chromeos-base/arc-networkd|\
  chromeos-base/arc-obb-mounter|\
  chromeos-base/arc-oemcrypto|\
  chromeos-base/arc-removable-media|\
  chromeos-base/arc-sdcard|\
  chromeos-base/arc-setup|\
  chromeos-base/arc-sslh-init|\
  chromeos-base/arcvm-common-scripts|\
  chromeos-base/arcvm-forward-pstore|\
  chromeos-base/arcvm-launch|\
  chromeos-base/arcvm-mojo-proxy|\
  chromeos-base/arcvm-vsock-proxy|\
  chromeos-base/atrusctl|\
  chromeos-base/attestation|\
  chromeos-base/authpolicy|\
  chromeos-base/biod|\
  chromeos-base/bluetooth|\
  chromeos-base/bootcomplete-embedded|\
  chromeos-base/bootcomplete-login|\
  chromeos-base/buffet|\
  chromeos-base/cdm-oemcrypto|\
  chromeos-base/chaps|\
  chromeos-base/chromeos-accelerometer-init|\
  chromeos-base/chromeos-activate-date|\
  chromeos-base/chromeos-adb-env|\
  chromeos-base/chromeos-auth-config|\
  chromeos-base/chromeos-bsp-baseboard-gru|\
  chromeos-base/chromeos-bsp-baseboard-kukui|\
  chromeos-base/chromeos-bsp-baseboard-oak|\
  chromeos-base/chromeos-bsp-baseboard-trogdor|\
  chromeos-base/chromeos-bsp-beaglebone_servo|\
  chromeos-base/chromeos-bsp-caroline-private|\
  chromeos-base/chromeos-bsp-endeavour-private|\
  chromeos-base/chromeos-bsp-gale|\
  chromeos-base/chromeos-bsp-hatch-private|\
  chromeos-base/chromeos-bsp-mobbase|\
  chromeos-base/chromeos-bsp-zork-private|\
  chromeos-base/chromeos-chrome|\
  chromeos-base/chromeos-config-tools|\
  chromeos-base/chromeos-cr50-scripts|\
  chromeos-base/chromeos-firewall-init|\
  chromeos-base/chromeos-firewall-init-mobbase|\
  chromeos-base/chromeos-imageburner|\
  chromeos-base/chromeos-init|\
  chromeos-base/chromeos-installer|\
  chromeos-base/chromeos-login|\
  chromeos-base/chromeos-machine-id-regen|\
  chromeos-base/chromeos-nat-init|\
  chromeos-base/chromeos-termina-scripts|\
  chromeos-base/chromeos-test-init|\
  chromeos-base/chromeos-trim|\
  chromeos-base/chunnel|\
  chromeos-base/crash-reporter|\
  chromeos-base/cros-camera|\
  chromeos-base/cros-camera-libs|\
  chromeos-base/cros-disks|\
  chromeos-base/crosdns|\
  chromeos-base/croslog|\
  chromeos-base/cryptohome|\
  chromeos-base/debugd|\
  chromeos-base/diagnostics|\
  chromeos-base/disk_updater|\
  chromeos-base/dlcservice|\
  chromeos-base/easy-unlock|\
  chromeos-base/factory_installer|\
  chromeos-base/fastrpc|\
  chromeos-base/feedback|\
  chromeos-base/gdisp|\
  chromeos-base/goldfishd|\
  chromeos-base/hammerd|\
  chromeos-base/hermes|\
  chromeos-base/iioservice|\
  chromeos-base/imageloader|\
  chromeos-base/infineon-firmware-updater|\
  chromeos-base/ip-peripheral|\
  chromeos-base/ippusb_bridge|\
  chromeos-base/ippusb_manager|\
  chromeos-base/kerberos|\
  chromeos-base/lorgnette|\
  chromeos-base/metrics|\
  chromeos-base/midis|\
  chromeos-base/ml|\
  chromeos-base/modemfwd|\
  chromeos-base/modemfwd-helpers-coral|\
  chromeos-base/modemfwd-helpers-dedede|\
  chromeos-base/modemfwd-helpers-drallion|\
  chromeos-base/modemfwd-helpers-hatch|\
  chromeos-base/modemfwd-helpers-nautilus|\
  chromeos-base/modemfwd-helpers-octopus|\
  chromeos-base/modemfwd-helpers-sarien|\
  chromeos-base/modemfwd-helpers-zork|\
  chromeos-base/mri_package|\
  chromeos-base/mtpd|\
  chromeos-base/nodejs-scripts|\
  chromeos-base/oobe_config|\
  chromeos-base/os_install_service|\
  chromeos-base/p2p|\
  chromeos-base/patchpanel|\
  chromeos-base/pdfc-scripts|\
  chromeos-base/permission_broker|\
  chromeos-base/power_manager|\
  chromeos-base/quickoffice|\
  chromeos-base/runtime_probe|\
  chromeos-base/shill|\
  chromeos-base/sirenia|\
  chromeos-base/smbprovider|\
  chromeos-base/swap-init|\
  chromeos-base/thermald|\
  chromeos-base/timberslide|\
  chromeos-base/tpm_manager|\
  chromeos-base/trunks|\
  chromeos-base/tty|\
  chromeos-base/u2fd|\
  chromeos-base/update_engine|\
  chromeos-base/usb_bouncer|\
  chromeos-base/userfeedback|\
  chromeos-base/viking-hid|\
  chromeos-base/virtual-file-provider|\
  chromeos-base/vm_host_tools|\
  chromeos-base/vpd|\
  chromeos-base/weaveauth|\
  chromeos-base/webserver|\
  chromeos-base/whining|\
  dev-util/hdctools|\
  media-libs/arc-camera-service|\
  media-libs/cros-camera-libcab|\
  media-libs/dlm|\
  media-libs/img-ddk|\
  media-sound/adhd|\
  net-dns/avahi-daemon|\
  net-firewall/conntrack-tools|\
  net-libs/libqrtr|\
  net-misc/modemmanager-next|\
  net-misc/nldaemon|\
  net-misc/rmtfs|\
  net-misc/tlsdate|\
  net-print/cups|\
  net-print/cups_proxy|\
  net-wireless/bluez|\
  net-wireless/floss|\
  net-wireless/iwlwifi_rescan|\
  net-wireless/ot-br-posix|\
  net-wireless/wpa_supplicant|\
  net-wireless/wpa_supplicant-2_8|\
  net-wireless/wpa_supplicant-2_9|\
  sys-apps/cecservice|\
  sys-apps/huddly-falcon-updater|\
  sys-apps/huddly-monitor|\
  sys-apps/fwupd|\
  sys-apps/mimo-houston-mcu-updater|\
  sys-apps/mimo-monitor|\
  sys-apps/moblab|\
  sys-apps/upstart|\
  sys-apps/ureadahead|\
  sys-apps/usbguard|\
  sys-power/dptf|\
  sys-process/audit|\
  virtual/chromeos-firewall|\
  virtual/target-jetstream-test-root)
    return 0
    ;;
  chromeos-base/arc-keymaster)  # We don't control the package name.  nocheck
    return 0
    ;;
  esac

  return 1
}

# Require an oom score line.
check_oom() {
  local config="$1"
  local relconfig="${config#${D}}"

  if ! grep -q '^oom score ' "${config}"; then
    local msg="${relconfig}: missing 'oom score' line."
    msg+=" Please see:\n  ${DOC_RESOURCE_URL}"
    if known_bad_oom; then
      eqawarn "${msg}"
    else
      eerror "${msg}"
      return 1
    fi
  else
    if grep -q '^oom score *-1000' "${config}"; then
      eerror "${relconfig}: Use 'oom score never' instead."
      return 1
    fi
  fi

  return 0
}

# Main entry point for this hook.
check() {
  local arg ret_oom=0

  for arg in "$@"; do
    if [[ -L "${arg}" ]]; then
      continue
    fi

    check_oom "${arg}"
    : $(( ret_oom += $? ))
  done

  if [[ ${ret_oom} -eq 0 ]] && known_bad_oom; then
    eqawarn "Please remove ${CATEGORY}/${PN} from known_bad_oom in $0."
  fi

  local ret=$(( ret_oom ))
  if [[ ${ret} -ne 0 ]]; then
    die "Init scripts have errors."
  fi
}

usage() {
  cat <<EOF
Usage: $0 <upstart init files>
EOF
  exit 1
}

main() {
  shopt -s nullglob

  if [[ -n ${D} ]]; then
    # Inside ebuild env.
    check "${D}"/etc/init/*.conf "${D}"/usr/local/etc/init/*.conf
  else
    if [[ $# -eq 0 ]]; then
      usage
    fi
    check "$@"
  fi
}
main "$@"
