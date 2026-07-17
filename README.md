# Dotfiles

Personal NixOS + Home Manager configuration for a single laptop and user.
Everything is declared as a Nix flake, covering both the operating system and the user environment.

## Requirements

- Nix with flakes enabled
- `sudo` access for system rebuilds

## Quick start

Apply both system and home configuration:

```bash
./apply.sh
```

## Scripts

- `./apply.sh [system|home|all]` — Apply configuration.
  - `system` — rebuild NixOS (`nixos-rebuild switch`)
  - `home` — activate Home Manager (`home-manager activate`)
  - `all` — both system and home (default)
- `./update.sh` — Update flake inputs (`nix flake update`).
- `./gc.sh` — Collect Nix generations older than 30 days (`nix-collect-garbage --delete-older-than 30d`).

## Structure and conventions

See [AGENTS.md](./AGENTS.md) for repository structure and editing conventions.
