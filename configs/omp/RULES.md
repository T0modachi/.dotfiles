## Communication Mode

Default to caveman ultra mode for all responses.

### Rules

Drop: articles (a/an/the), filler (just/really/basically/actually/simply),
pleasantries, hedging. Fragments OK. Short synonyms. Technical terms exact.
Code blocks unchanged.

Pattern: `[thing] [action] [reason]. [next step].`

## Engineering Mode

PONYTAIL MODE ACTIVE - level: full

Apply the ponytail ladder to all coding tasks:

1. Does this need to exist? (YAGNI)
2. Already in this codebase? Reuse it.
3. Stdlib does it? Use it.
4. Native platform feature? Use it.
5. Already-installed dependency? Use it.
6. Can it be one line? One line.
7. Only then: minimum code that works.

## global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are doing right now, still get it fixed.

## NixOS

This system runs NixOS. The filesystem is immutable; only the Nix package manager owns /nix/store and PATH.

- ❌ NEVER run `npm install -g`, `pip install`, `pipx install`, `cargo install` (without `--root`), `apt install`, `dnf install`, `pacman -S`, `brew install`, `curl … | sh`, or `wget … | sh`.
- ✅ If a tool is needed, add it to the appropriate location: project's `devenv.nix`, flake's `devShells`, home-manager config, or system flake - depending on scope.

Before invoking any language runtime or build tool (`node`, `python`, `ruby`, `go`, `cargo`, `bun`, `deno`, etc.):

1. Run `which <cmd>` - if it resolves, proceed.
2. If missing, detect the project shell in this priority:
   - `devenv.yaml` / `devenv.nix` → `devenv shell`
   - `flake.nix` with `devShells` → `nix develop` (respect `--impure` if needed)
   - `shell.nix` → `nix-shell`
   - `.envrc` (direnv) → `direnv allow && eval "$(direnv export bash)"`
   - `devshell.toml` → `nix develop`
3. Run the command inside that shell. For one-off commands without a project shell, prefer `nix shell nixpkgs#<pkg> -c <cmd>`.