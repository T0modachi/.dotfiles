# AGENTS.md — Guía para agentes de codificación

> Este archivo fue elaborado con el contexto extraído del índice de CodeGraph (`codegraph.db`) del repositorio. Utilízalo como fuente de convenciones, estructura y puntos de atención antes de modificar dotfiles.

## 1. Resumen del proyecto

Este repositorio es una configuración de **NixOS + Home Manager** para una sola máquina y un solo usuario. Declara todo como un flake de Nix (`flake.nix`) y gestiona tanto el sistema operativo (NixOS) como el entorno de usuario (Home Manager).

- **Sistema fijo:** `x86_64-linux`
- **Canal de Nixpkgs:** `nixos-unstable`
- **Home Manager:** rama `master` con `follows` a `nixpkgs`
- **Otros inputs clave:** `nixvim`, `llm-agents`, `mcp-servers-nix`, `devenv`

## 2. Estructura del repositorio

```
.
├── flake.nix                  # Punto de entrada. Define nixosConfigurations y homeManagerConfigurations
├── system/
│   ├── default.nix            # Agrega todos los módulos del sistema
│   ├── hardware.nix           # Hardware (auto-generado por nixos-generate-config)
│   ├── boot.nix               # Bootloader (systemd-boot + EFI)
│   ├── locale.nix             # Timezone, locale, keymap
│   ├── audio.nix              # Pipewire, rtkit
│   ├── display.nix            # X11, GDM, GNOME, Niri, Firefox, fuentes
│   ├── networking.nix         # NetworkManager, hostname, firewall (syncthing)
│   ├── nix-settings.nix       # Flakes, GC, trusted-users, allowUnfree, stateVersion
│   ├── packages.nix           # Paquetes del sistema (herramientas base)
│   └── users.nix              # Definición de usuario T0modachi
├── home/
│   ├── default.nix            # Agrega todos los módulos del home
│   ├── services.nix           # stateVersion, username, home-manager, syncthing, dconf
│   ├── packages.nix           # Paquetes de usuario (apps, tools, dev)
│   ├── shell.nix              # Bash, Zsh, starship, direnv
│   ├── git.nix                # Git config + delta
│   ├── wayland.nix            # Waybar, fuzzel, swaylock, mako, swayidle, polkit
│   ├── gaming.nix             # Wine, Vulkan, DXVK, Mesa, Protonup
│   └── dotfiles.nix           # home.file — symlinks a configs
├── packages/
│   └── zen.nix                # Empaquetado custom de Zen Browser (AppImage)
├── ghostty/                   # Configuración de Ghostty
├── starship/                  # Prompt de Starship
├── niri/                      # Configuración del compositor Niri
├── omp/
│   ├── config.yml             # Configuración de Oh My Pi
│   └── mcp.json               # Servidores MCP disponibles (context7, codegraph)
└── apply.sh                   # Script unificado de activación
```

## 3. Flake outputs

`flake.nix` expone dos tipos de salida:

### NixOS configurations

- `nix-laptop` — laptop NixOS. Usa `./system` (default.nix) como módulo raíz.

### Home Manager configurations

- `T0modachi` — entorno de usuario. Usa `./home` (default.nix) como módulo raíz.

## 4. Convenciones de edición

- **Nix es funcional:** no modifiques variables, no uses impureza. Todos los paths a recursos del repo deben resolver al Nix store a través de `source = ../../ruta/relativa`.
- **Rutas relativas:** en `home/dotfiles.nix` usa `../` para subir desde `home/` hasta la raíz del repo.
- **No hardcodees hashes si no es necesario:** el `zen.nix` usa un hash fijo de AppImage; si se actualiza Zen, hay que recalcular el `sha256`.
- **Comentarios:** en español para consistencia con `omp/config.yml` y muchos comentarios existentes.
- **Permitir unfree:** centralizado en `system/nix-settings.nix` (nixpkgs.config). No lo dupliques en otros módulos.
- **Paquetes inseguros permitidos:** `electron-25.9.0`, `electron-27.3.11`, `electron-28.3.3`, `electron-39.8.10`. No los elimines si aún son necesarios.

## 5. Módulos del sistema (`system/`)

Cada archivo es un módulo NixOS con una responsabilidad clara:

| Módulo | Contenido |
|---|---|
| `hardware.nix` | Hardware auto-generado. No editar manualmente. |
| `boot.nix` | systemd-boot, EFI, configurationLimit |
| `locale.nix` | Timezone (Santiago), locale (en_US + es_CL), keymap latam |
| `audio.nix` | Pipewire (ALSA + Pulse), rtkit |
| `display.nix` | X11, GDM, GNOME, Niri, Firefox, impresión, nerd-fonts |
| `networking.nix` | NetworkManager, hostname, firewall (puertos syncthing) |
| `nix-settings.nix` | Flakes, GC semanal, trusted-users, allowUnfree, stateVersion |
| `packages.nix` | Solo herramientas base del sistema (vim, git, compiladores, etc.) |
| `users.nix` | Usuario T0modachi (wheel + networkmanager), sudo |

## 6. Módulos del home (`home/`)

Cada archivo es un módulo Home Manager con una responsabilidad clara:

| Módulo | Contenido |
|---|---|
| `services.nix` | stateVersion, username, homeDirectory, sessionVariables, syncthing, dconf |
| `packages.nix` | Apps, tools de desarrollo, CLI tools, wayland utils |
| `shell.nix` | Bash, Zsh (oh-my-zsh), starship, direnv |
| `git.nix` | Git config (user, mail), delta (diff viewer) |
| `wayland.nix` | Waybar, fuzzel, swaylock, alacritty, mako, swayidle, polkit |
| `gaming.nix` | Wine, Vulkan, DXVK, Mesa, Protonup-Qt |
| `dotfiles.nix` | Symlinks: starship, ghostty, niri, omp |

## 7. Script de aplicación

`apply.sh` unifica la activación:

```bash
./apply.sh          # Aplica sistema + home (default)
./apply.sh system   # Solo nixos-rebuild switch
./apply.sh home     # Solo home-manager activate
```

Otros scripts:
- `update.sh` — `nix flake update`
- `gc.sh` — `nix-collect-garbage --delete-older-than 30d`

## 8. MCP y CodeGraph

El repo integra CodeGraph. El índice se encuentra en `.codegraph/codegraph.db` y se actualiza con:

```bash
codegraph sync .
```

Servidores MCP activos en `omp/mcp.json`:
- `context7` — documentación de librerías.
- `codegraph` — grafo de código del propio repo.

Después de cambios grandes en Nix/Lua, reindexa para que los agentes posteriores vean el código actualizado.

## 9. Puntos de atención / riesgos

- **`system/hardware.nix`** es auto-generada por `nixos-generate-config`. No la edites a mano salvo que el hardware cambie.
- **`.codegraph/`** está ignorado por git. No commitees la base de datos.
- **`result`** es un symlink de Nix build. Está en `.gitignore`.
- **`home/dotfiles.nix`** usa `force = true` para Niri. Sobrescribe sin preguntar.
- **No dupliques `allowUnfree`** — ya está en `system/nix-settings.nix`.
- **`system/packages.nix`** es solo para herramientas base del sistema. Apps y tools de usuario van en `home/packages.nix`.

## 10. Cómo verificar un cambio

1. **Evaluación:** `nix flake check`
2. **Formato Nix:** `nixfmt` o `alejandra` si están disponibles.
3. **Aplicar:** `./apply.sh [system|home|all]`
4. **Reindexar CodeGraph:** `codegraph sync .`

## 11. Reglas rápidas para el agente

- **Agrega paquetes de usuario a `home/packages.nix`, no a `system/packages.nix`.**
- **No modifiques `system/hardware.nix`.**
- **No elimines comentarios en español** sin motivo claro.
- **No agregues inputs al flake sin discutirlo;** cada input aumenta el tiempo de evaluación y lock.
- **Prefiere `home.file` con rutas relativas al Nix store** antes que escribir templates `.text` con `builtins.readFile`.
- **Después de editar, ejecuta `codegraph sync .`** para mantener el índice actualizado.
- **Nuevos módulos:** un archivo por responsabilidad. Si un módulo crece más de ~50 líneas, considera dividirlo.

---

*Generado con el contexto de CodeGraph del propio repositorio.*
