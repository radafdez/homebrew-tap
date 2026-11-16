cask "supabase-switch" do
  version "1.3.1"
  sha256 "acf7bc6f7d1e2f8fc4b59f4ea802cff2a6a5d3545d633530df43203796355943"

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
    Supabase Switch is not notarized by Apple. The first time, open it from
    /Applications and click "Open Anyway" in System Settings → Privacy &
    Security. Do that before using `sbswitch`: until the app has run once,
    macOS stops the command too. After that the app updates itself.
  EOS
end
