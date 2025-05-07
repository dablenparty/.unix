#!/usr/bin/env bash

# keep -x for clarity
set -xe

# NOTE: this script solves an intermittent issue described here:
# https://discuss.cachyos.org/t/pacman-signature-is-invalid/3239/25

if ((EUID != 0)); then
  echo "please re-run this script as root!" 1>&2
  exit 100
fi

rm -vrf /var/lib/pacman/sync
# re-rate mirrors
/usr/bin/env cachyos-rate-mirrors
# re-initialize keyring
pacman-key --init
pacman-key --populate
# refresh all sync databases and upgrade system
pacman -Syyu
