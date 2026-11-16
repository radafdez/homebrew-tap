#!/bin/bash
# Installs the cask from this checkout's last commit, checks it, and removes
# it again with --zap. Meant for a CI runner, a Mac with nothing to lose: it
# installs into /Applications and links sbswitch into Homebrew's bin.
#
# Instala el cask desde el último commit de esta copia, lo comprueba y lo
# vuelve a quitar con --zap. Pensado para un runner de CI, un Mac sin nada que
# perder: instala en /Applications y enlaza sbswitch en el bin de Homebrew.
set -euo pipefail
cd "$(dirname "$0")/.."

cask=radafdez/tap/supabase-switch
app="/Applications/Supabase Switch.app"
link="$(brew --prefix)/bin/sbswitch"
version="$(sed -n -E 's/^  version "([^"]*)"$/\1/p' Casks/supabase-switch.rb)"

brew untap radafdez/tap 2> /dev/null || true
brew tap radafdez/tap "$PWD"
brew trust radafdez/tap
# Only the cask: `brew style` on the whole tap would also hold these scripts
# to Homebrew's own shell style. / Solo el cask: `brew style` sobre el tap
# entero también juzgaría estos scripts con el estilo de shell de Homebrew.
brew style --cask "$cask"
brew audit --cask --strict --online "$cask"

brew install --cask "$cask"
installed="$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$app/Contents/Info.plist")"
[ "$installed" = "$version" ] || { echo "Installed $installed, expected $version" >&2; exit 1; }
[ "$(readlink "$link")" = "$app/Contents/MacOS/sbswitch" ] || { echo "$link does not point into the app" >&2; exit 1; }
/usr/libexec/PlistBuddy -c "Print SUPublicEDKey" "$app/Contents/Info.plist" > /dev/null \
  || { echo "The app has no update key: Sparkle could never update it" >&2; exit 1; }
echo "Quarantine on the app: $(xattr -p com.apple.quarantine "$app" 2> /dev/null || echo none)"

brew uninstall --cask --zap "$cask"
[ ! -e "$app" ] && [ ! -L "$link" ] || { echo "Uninstall left the app or the link behind" >&2; exit 1; }
echo "supabase-switch $version installs, links sbswitch and uninstalls cleanly."
