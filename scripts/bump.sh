#!/bin/bash
# Points the cask at one release of Keyturn:
#
#     scripts/bump.sh 1.3.1
#
# The checksum comes from that release's SHA256SUMS.txt; `brew install` then
# refuses a zip that does not match it.
#
# Apunta el cask a una versión de Keyturn. La suma sale del
# SHA256SUMS.txt de esa versión; `brew install` rechaza después un zip que no
# coincida.
set -euo pipefail
cd "$(dirname "$0")/.."

version="${1:?Usage: scripts/bump.sh <version>}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Not a version: $version" >&2; exit 1; }
zip="Keyturn-$version.zip"
sums="$(curl -fsSL "https://github.com/radafdez/keyturn/releases/download/v$version/SHA256SUMS.txt")"
sha256="$(awk -v zip="$zip" '$2 == zip { print $1 }' <<< "$sums")"
[[ "$sha256" =~ ^[0-9a-f]{64}$ ]] || { echo "No checksum for $zip in the release" >&2; exit 1; }

cask=Casks/keyturn.rb
sed -i.bak -E \
  -e "s/^  version \"[^\"]*\"$/  version \"$version\"/" \
  -e "s/^  sha256 \"[0-9a-f]{64}\"$/  sha256 \"$sha256\"/" "$cask"
rm "$cask.bak"
grep -q "^  version \"$version\"$" "$cask" && grep -q "^  sha256 \"$sha256\"$" "$cask" \
  || { echo "Could not update $cask" >&2; exit 1; }
echo "$cask: $version ($sha256)"
