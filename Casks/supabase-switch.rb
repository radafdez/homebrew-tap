cask "supabase-switch" do
  version "1.3.2"
  sha256 "c5c3d27c0e27f2afb230bfdf12efba8b2047d3d31d52da5c15a92cfa6ebad4d1"

  url "https://github.com/radafdez/supabase-switch/releases/download/v#{version}/Supabase-Switch-#{version}.zip"
  name "Supabase Switch"
  desc "Menu bar app to switch the account the Supabase CLI is logged in as"
  homepage "https://github.com/radafdez/supabase-switch"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself through Sparkle, with updates signed by the
  # project's EdDSA key, so `brew upgrade` does not reinstall it.
  auto_updates true
  depends_on macos: :ventura

  app "Supabase Switch.app"
  binary "#{appdir}/Supabase Switch.app/Contents/MacOS/sbswitch"

  uninstall quit: "com.raisapp.supabase-switch"

  # The access tokens live in the login Keychain, under "Supabase Switch";
  # remove them there if you want them gone too.
  zap trash: [
    "~/Library/Application Support/SupabaseSwitch",
    "~/Library/Caches/com.raisapp.supabase-switch",
    "~/Library/HTTPStorages/com.raisapp.supabase-switch",
    "~/Library/Preferences/com.raisapp.supabase-switch.plist",
  ]

  caveats <<~EOS
    Supabase Switch is not notarized by Apple, and Homebrew installs it
    quarantined: macOS stops `sbswitch`, and the AI agents that use it, until
    the mark is removed. Run this once:

      xattr -dr com.apple.quarantine "#{appdir}/Supabase Switch.app"

    Settings → AI agents in the app shows the same command while it is needed.
    After that the app updates itself.
  EOS
end
