cask "keyturn" do
  version "1.5.1"
  sha256 "8f16ee585ce360356a0bdd275a054f4bd34c93aec0026219d3047b1fa480ea3d"

  url "https://github.com/radafdez/keyturn/releases/download/v#{version}/Keyturn-#{version}.zip"
  name "Keyturn"
  desc "Menu bar app to switch the account the Supabase CLI is logged in as"
  homepage "https://github.com/radafdez/keyturn"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself through Sparkle, with updates signed by the
  # project's EdDSA key, so `brew upgrade` does not reinstall it.
  auto_updates true
  depends_on macos: :ventura

  app "Keyturn.app"
  binary "#{appdir}/Keyturn.app/Contents/MacOS/keyturn"

  uninstall quit: "com.raisapp.keyturn"

  # The access tokens live in the login Keychain, under "Keyturn";
  # remove them there if you want them gone too.
  zap trash: [
    "~/Library/Application Support/Keyturn",
    "~/Library/Caches/com.raisapp.keyturn",
    "~/Library/HTTPStorages/com.raisapp.keyturn",
    "~/Library/Preferences/com.raisapp.keyturn.plist",
  ]

  caveats <<~EOS
    Keyturn is not notarized by Apple, and Homebrew installs it quarantined:
    macOS stops `keyturn`, and the AI agents that use it, until the mark is
    removed. Run this once:

      xattr -dr com.apple.quarantine "#{appdir}/Keyturn.app"

    Settings → AI agents in the app shows the same command while it is needed.
    After that the app updates itself.
  EOS
end
