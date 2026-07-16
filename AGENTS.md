# AGENTS.md — Guía para agentes de codificación

> Este archivo fue elaborado con el contexto extraído del índice de CodeGraph (`codegraph.db`) del repositorio. Utilízalo como fuente de convenciones, estructura y puntos de atención antes de modificar dotfiles.

## 1. Resumen del proyecto

Este repositorio es una configuración de **NixOS + Home Manager** para varias máquinas y usuarios. Declara todo como un flake de Nix (`flake.nix`) y gestiona tanto el sistema operativo (NixOS) como los entornos de usuario (Home Manager).

- **Sistema fijo:** `x86_64-linux`
- **Canal de Nixpkgs:** `nixos-unstable`
- **Home Manager:** rama `master` con `follows` a `nixpkgs`
- **Otros inputs clave:** `nixvim`, `llm-agents`, `mcp-servers-nix`, `devenv`

## 2. Estructura del repositorio

```
.
├── flake.nix                  # Punto de entrada. Define nixosConfigurations y homeManagerConfigurations
├── system/
│   ├── common/                # Opciones compartidas entre NixOS configs
│   │   ├── common-options.nix
│   │   └── packages.nix
│   ├── nix-laptop/            # Configuración personal (laptop NixOS)
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── work-laptop/           # Configuración de trabajo
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── users/
│   ├── T0modachi/             # Home Manager para usuario personal
│   │   └── home.nix
│   └── jvergara-ialink/       # Home Manager para usuario de trabajo
│       └── home.nix
├── packages/
│   └── zen.nix                # Empaquetado custom de Zen Browser (AppImage)
├── nvim/                      # Configuración de Neovim (Lua, se carga vía Nixvim en inputs)
├── zellij/                    # Configuración de Zellij
├── ghostty/                   # Configuración de Ghostty
├── starship/                  # Prompt de Starship
├── niri/                      # Configuración del compositor Niri
├── hypr/                      # Configuración de Hyprland (actualmente no enlazada)
├── tmux/                      # Configuración de Tmux (no enlazada por HM en T0modachi)
├── omp/
│   ├── config.yml             # Configuración de Oh My Pi
│   └── mcp.json               # Servidores MCP disponibles (context7, codegraph)
└── apply-*.sh                 # Scripts de activación por perfil
```

## 3. Flake outputs

`flake.nix` expone dos tipos de salida:

### NixOS configurations

- `nix-laptop` — laptop personal. Recibe `inputs` como `specialArgs`.
- `work-laptop` — laptop de trabajo. No recibe `inputs` en `specialArgs`, así que no asumas que está disponible en esos módulos.

### Home Manager configurations

- `T0modachi` — entorno personal. Usa `inputs` y `outputs` como `extraSpecialArgs`.
- `jvergara-ialink` — entorno de trabajo. También recibe `inputs` y `outputs`.

## 4. Convenciones de edición

- **Nix es funcional:** no modifiques variables, no uses impureza. Todos los paths a recursos del repo deben resolver al Nix store a través de `source = ../../ruta/relativa`.
- ** Rutas relativas:** en `home.file` usa `../../` para salir de `users/<usuario>/` hasta la raíz del repo.
- **No hardcodees hashes si no es necesario:** el `zen.nix` usa un hash fijo de AppImage; si se actualiza Zen, hay que recalcular el `sha256`.
- **Comentarios:** el repo mezcla español e inglés. Si vas a agregar comentarios explicativos largos, preferiblemente en español para mantener consistencia con `omp/config.yml` y muchos comentarios existentes.
- **Permitir unfree:** `flake.nix` configura `allowUnfree = true` y un `allowUnfreePredicate` que acepta todo. No cambies esto sin justificar.
- **Paquetes inseguros permitidos:** `electron-25.9.0`, `electron-27.3.11`, `electron-28.3.3`. No los elimines si aún son necesarios para alguna app.

## 5. Gestión de dotfiles con Home Manager

Cada `home.nix` declara:

- `home.username` y `home.homeDirectory` (fijos por usuario; no los cambies sin autorización).
- `home.packages` — paquetes de usuario.
- `home.file` — symlinks a archivos de este repo.
- `programs.*` — configuración de programas gestionados por Home Manager.

### Diferencias entre usuarios

- **T0modachi** usa:
  - Niri + Hyprland (Niri enlazado con `force = true`)
  - Zellij como directorio recursivo
  - Oh My Pi config (`~/.omp/agent/*`)
  - Waybar, Swaylock, Mako, Swayidle, Polkit-gnome

- **jvergara-ialink** usa:
  - Zellij con un solo `config.kdl` y un layout custom (`zellij_templates/ariztia.kdl`)
  - SSH config
  - No enlaza Niri ni Oh My Pi

## 6. Scripts de aplicación

Antes de modificar nada, verifica qué script corresponde al perfil:

| Script | Perfil | Comando |
|---|---|---|
| `apply-personal-laptop.sh` | NixOS laptop personal | `sudo nixos-rebuild switch --flake .#nix-laptop` |
| `apply-work-laptop.sh` | NixOS laptop trabajo | `sudo nixos-rebuild switch --flake .#work-laptop` |
| `apply-T0modachi.sh` | Home Manager personal | `nix build .?submodules=1#homeManagerConfigurations.T0modachi.activationPackage && ./result/activate` |
| `apply-jvergara-ialink.sh` | Home Manager trabajo | `nix build .?submodules=1#homeManagerConfigurations.jvergara-ialink.activationPackage && ./result/activate` |
| `update.sh` | Actualizar inputs | `nix flake update` |

> **Nota:** todos los scripts hacen `pushd ~/.dotfiles` primero.

## 7. MCP y CodeGraph

El repo ya integra CodeGraph. El índice se encuentra en `.codegraph/codegraph.db` y se actualiza con:

```bash
codegraph sync .
```

Para reconstruir desde cero:

```bash
codegraph index .
```

Servidores MCP activos en `omp/mcp.json`:

- `context7` — documentación de librerías.
- `codegraph` — grafo de código del propio repo.

Después de cambios grandes en Nix/Lua, reindexa para que los agentes posteriores vean el código actualizado.

## 8. Puntos de atención / riesgos

- **Hardware configurations** (`system/*/hardware-configuration.nix`) son generadas por `nixos-generate-config`. No las edites a mano salvo que sepas que el hardware cambió.
- **`.codegraph/`** está ignorado por git (ver `.codegraph/.gitignore`). No commitees la base de datos.
- **`result`** es un symlink de Nix build. Está en `.gitignore` (raíz). No lo commitees.
- **`users/T0modachi/home.nix`** usa `force = true` en el enlace de Niri. Esto sobrescribe `~/.config/niri/config.kdl` sin preguntar.
- **`inputs`** no está disponible para `work-laptop` en `specialArgs`; solo `nix-laptop` lo recibe.

## 9. Cómo verificar un cambio

1. **Evaluación:** `nix flake check` o `nix build .#<output>.config.system.build.toplevel` (NixOS) / `nix build .#homeManagerConfigurations.<usuario>.activationPackage`.
2. **Formato Nix:** `nixfmt` o `alejandra` si están disponibles.
3. **Aplicar:** usa el script de activación correspondiente.
4. **Reindexar CodeGraph:** `codegraph sync .` para que el contexto del repo refleje los cambios.

## 10. Reglas rápidas para el agente

- **No asumas estructura de un solo usuario.** Pregunta o verifica si el cambio afecta T0modachi, jvergara-ialink, ambos, o NixOS.
- **No modifiques `hardware-configuration.nix`.**
- **No elimines comentarios en español** sin motivo claro.
- **No agregues inputs al flake sin discutirlo;** cada input aumenta el tiempo de evaluación y lock.
- **Prefiere `home.file` con rutas relativas al Nix store** antes que escribir templates `.text` con `builtins.readFile` salvo que sea necesario.
- **Después de editar, ejecuta `codegraph sync .`** para mantener el índice actualizado.

---

*Generado con el contexto de CodeGraph del repositorio.*
