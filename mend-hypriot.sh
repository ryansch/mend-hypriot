#!/bin/bash
set -e
set +f
shopt -s nullglob 

# Adapted from: https://unix.stackexchange.com/a/430415

img="${1:?}"
dev="$(losetup --show -f -P "$img")"
echo "$dev"


function cleanup {
  cd /

  for part in "$dev"?*; do
    if [[ "$part" = "${dev}p*" ]]; then
      part="${dev}"
    fi
    dst="/mnt/$(basename "$part")"
    umount "$dst"
  done

  losetup -d "$dev"
}

trap cleanup EXIT

for part in "$dev"?*; do
  if [[ "$part" = "${dev}p*" ]]; then
    part="${dev}"
  fi
  dst="/mnt/$(basename "$part")"
  echo "$dst"
  mkdir -p "$dst"
  mount "$part" "$dst"
done

cd /mnt/$(basename ${dev}p2)
ln -sf /uboot/user-data var/lib/cloud/seed/nocloud-net/user-data
ln -sf /uboot/meta-data var/lib/cloud/seed/nocloud-net/meta-data
ls -l var/lib/cloud/seed/nocloud-net/
