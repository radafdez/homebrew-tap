# radafdez/tap

Homebrew casks by [radafdez](https://github.com/radafdez).

| Cask | What it is |
|------|------------|
| [`supabase-switch`](https://github.com/radafdez/supabase-switch) | Switch the account the Supabase CLI is logged in as, from the menu bar or with `sbswitch` |

## Install

```bash
brew install --cask radafdez/tap/supabase-switch
```

Naming the cask in full trusts only that cask, not the rest of this tap.

Supabase Switch is **not notarized** by Apple, and Homebrew installs it
quarantined: macOS stops `sbswitch`, and the AI agents that use it, until the
mark is removed. Run this once after installing:

```bash
xattr -dr com.apple.quarantine "/Applications/Supabase Switch.app"
```

**Settings → AI agents** in the app shows the same command while it is needed.

After that the app updates itself through
[Sparkle](https://sparkle-project.org), with every update signed by the
project's key, so `brew upgrade` leaves it alone (`brew upgrade --greedy`
reinstalls it anyway). To remove it:

```bash
brew uninstall --cask supabase-switch          # the app and sbswitch
brew uninstall --cask --zap supabase-switch    # also your accounts list and settings
```

The access tokens stay in the login Keychain, under “Supabase Switch”.

## How the cask is kept up to date

Once a day, [`bump.yml`](.github/workflows/bump.yml) looks for a new release
of Supabase Switch, takes its checksum from the release's `SHA256SUMS.txt`,
installs and uninstalls it on a GitHub macOS runner, and only then pushes the
change. Every push and pull request runs the same check
([`test.yml`](.github/workflows/test.yml)).

GitHub turns scheduled workflows off after 60 days without activity in the
repository. If that happens, the cask simply stays on its version until the
workflow is turned back on in **Actions**, or run by hand there with **Run
workflow**. The app installed from it keeps updating itself either way.

---

## Español

```bash
brew install --cask radafdez/tap/supabase-switch
```

Al nombrar el cask completo solo se confía en ese cask, no en el resto del
tap. Supabase Switch **no está notarizada** por Apple, y Homebrew la instala en
cuarentena: macOS para `sbswitch`, y con él a los agentes de IA, hasta que se
quita la marca. Ejecuta esto una vez tras instalarla:

```bash
xattr -dr com.apple.quarantine "/Applications/Supabase Switch.app"
```

**Ajustes → Agentes de IA** en la app enseña la misma orden mientras haga
falta. Después se actualiza sola con
Sparkle, y `brew upgrade` no la toca. `brew uninstall --cask --zap
supabase-switch` la quita junto con tu lista de cuentas y tus ajustes; los
tokens siguen en el Llavero.

## License

[MIT](LICENSE).
