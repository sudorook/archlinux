#! /bin/bash
set -eu

#
# Check that all the packages in ../packages actually exist.
#

function clean_pkgname() {
  echo "${1}" | sed -e "s,+$,\\\+,g"
}

pkgdir=../packages

for file in ${pkgdir}/*; do
  echo $(basename ${file})

  # Skip the wine list if multilib is not enabled.
  if [ "${file}" = "../packages/wine.list" ]; then
    if ! $(pacman -Sl multilib >/dev/null 2>&1); then
      echo "[multilib] not enabled. Skipping."
      echo
      continue
    fi
  fi

  missing=false
  for package in $(cat ${file}); do
    if pacman -Ss ^$(clean_pkgname "${package}")$ >/dev/null; then
      echo "✓ ${package}"
    else
      missing=true
      echo "✗ ${package}"
    fi
  done

  echo
done

if $missing; then exit 1; fi
