# TODO: nix-darwin Modularization and Cleanup

This document tracks follow‑ups to simplify and harden the nix‑darwin setup while keeping maintainability high. Items are grouped by theme, with concrete tasks and steps. Answer the questions in the next section so tasks can be tailored precisely.

---

## A. Imports & Module Structure

- [x] Create a single import for system modules
  - [x] Add `modules/system/default.nix` that imports all sibling modules (e.g., `packages.nix`, `fonts.nix`, `applications.nix`, `defaults.nix`, `core.nix`, `homebrew.nix`, `proxychains.nix`).
  - [x] Update `darwin-configuration.nix` to import only `./modules/system/default.nix`.
  - [x] Keep host-specific overrides in `darwin-configuration.nix` only.

- [x] Consolidate tiny modules
  - [x] Create `modules/system/core.nix` combining:
    - `nix.nix` (flakes feature), `nixpkgs.nix` (allowUnfree), `programs.nix` (zsh, gnupg), and `terminal.nix` (terminfo outputs).
  - [x] Create `modules/system/defaults.nix` combining:
    - `dock.nix` and `ui.nix` into one `system.defaults` module.
  - [x] Update `modules/system/default.nix` to import the consolidated files.
  - [x] Remove the now-redundant tiny modules (`nix.nix`, `nixpkgs.nix`, `programs.nix`, `terminal.nix`, `dock.nix`, `ui.nix`) to avoid duplication.

- [x] Options policy
  - [x] At the top of `modules/system/default.nix`, add a short note: “Modules are plain config by default; add options only when clearly useful.”

## B. Packages Policy & Lists

- [x] Document package policy (README or module header)
  - [x] State: Use Nix for CLI/dev tools; use Homebrew for GUI apps/macOS bundles (preferred for Dock apps).

- [x] Alphabetize lists
  - [x] Sort `environment.systemPackages` alphabetically in `modules/system/packages.nix`.
  - [x] Sort `homebrew.brews` and `homebrew.casks` alphabetically in `modules/system/homebrew.nix`.

- [ ] Align Dock with installs (Homebrew for GUI apps)
  - [ ] Ensure Homebrew casks include: `google-chrome`, `telegram` (or `telegram-desktop`?), and `windsurf` (confirm cask name).
  - [ ] Update `system.defaults.dock.persistent-apps` to reference `/Applications/Google Chrome.app`, `/Applications/Telegram.app`, and `/Applications/Windsurf.app` instead of Nix store paths.
  - [ ] Remove any Nix `pkgs.*` Dock app references for these GUI apps.

## C. Applications Aliasing

- [x] Keep current aliasing strategy
  - [x] Keep `modules/system/applications.nix` logic that aliases both system and HM apps to `/Applications`.
  - [x] Add comments explaining the `mkForce` override, why aliases are created, and tradeoffs vs. HM’s default `~/Applications`.

- [x] Optional hardening
  - [x] Replace `head -1` with iterating all `home-manager-applications*` paths to avoid missing multiple HM profiles.

## D. Formatting & Tooling

- [x] Install formatter (alejandra)
  - [x] Add `alejandra` to `environment.systemPackages` in `modules/system/packages.nix` (simple, always available).
  - [x] Optionally add a `devShell` in `flake.nix` including `alejandra` for contributors who prefer shells.

- [x] Add a Makefile
  - [x] `fmt`: run `alejandra .`
  - [x] `fmt-check`: run `alejandra -c .`
  - [x] `check`: run `nix flake check` and `make fmt-check`

- [ ] Optional: Pre-commit hooks
  - [ ] Add a simple `.pre-commit-config.yaml` using `pre-commit` with a `nixpkgs-fmt`/`alejandra` hook.
  - [ ] Document installation or add a devShell with `pre-commit`.

- [ ] Optional: CI (GitHub Actions)
  - [ ] Add workflow to run `nix flake check` and formatting checks on PRs.

## E. Documentation

- [x] Update README.md
  - [x] Describe structure (hosts vs modules, HM vs nix‑darwin; multi-host out of scope now).
  - [x] Document package policy (Nix for CLI/dev, Homebrew for GUI; Dock apps prefer Homebrew but exceptions allowed).
  - [x] Document aliasing behavior: both system and HM apps are aliased into `/Applications` by activation script (HM’s default `~/Applications` may still exist but `/Applications` is primary).
  - [x] Add usage snippet: `darwin-rebuild switch --flake .#cloud`.

- [x] Add module headers
  - [x] At the top of key modules (`modules/system/default.nix`, `applications.nix`, `homebrew.nix`, `packages.nix`), add brief comments explaining intent and any special behavior.

## F. Backlog (Multi-Host, deferred)

- [ ] Application aliasing policy revisit
  - [ ] Re-evaluate keeping both system and HM aliases under `/Applications` (current script) versus simplifying to system-only and letting HM apps live under `~/Applications/Home Manager Apps`.
  - [ ] Capture pros/cons: single UX surface in `/Applications` vs reduced imperative logic and closer-to-default HM behavior.
  - [ ] If switching to system-only, ensure README clearly documents HM app location and remove the HM loop from `applications.nix`.

- [ ] Hosts layout and flake integration (defer until multi-host is needed)
  - [ ] Create `hosts/<name>/darwin.nix` and move host-specific bits there.
  - [ ] Update `flake.nix` to load from hosts; pass host constants via `specialArgs` if helpful.

## G. Validation

- [ ] Build and apply
  - [ ] `darwin-rebuild switch --flake .#cloud`
  - [ ] Verify Dock entries appear and open the expected apps.
  - [ ] Verify `/Applications` aliases exist for intended system/HM apps.

- [ ] Lint/format
  - [ ] Run `make fmt` and commit any changes.
  - [ ] Run `make check` and fix issues.

---

## Notes
- Favor the simplest approach that works: consolidate where it reduces mental overhead; avoid premature optionization.
- Keep lists sorted to reduce merge churn and speed reviews.
- Document the policy so future changes stay consistent.
