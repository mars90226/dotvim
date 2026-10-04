# Repository guidance

## Configuration layout

- Start at `init.lua` when tracing startup. Profile and basic setup run before
  plugin selection, lazy.nvim setup, and `core` setup.
- `lua/plug/plugins/` contains lazy.nvim plugin specifications, grouped by topic.
- `lua/vimrc/` contains shared helpers and configuration, including `lsp.lua`;
  `lua/vimrc/plugins/` contains plugin-specific helpers and setup modules.
- `lua/core/` contains editor behavior initialized by `lua/core/init.lua`.
- Check `lua/plug/plugin_choose.lua` and existing profile/environment checks when
  changing plugin availability. Preserve support for light/resource-limited modes.
- Extend the relevant existing module and follow its surrounding patterns.

## Local conventions

- Use `<M-…>` notation for Alt/Meta mappings. Check existing mappings and their
  modes before choosing a key; follow adjacent keymap definitions.
- Lua uses two-space indentation, as defined in `stylua.toml` and `.editorconfig`.
  Limit formatting to files changed for the task.
- Verify plugin options against the installed plugin's documentation or source;
  use `lazy-lock.json` to identify the pinned revision.

## Verification

- Run `just test` for changes to shared Lua utilities covered by `spec/`.
  It invokes Busted; inspect the specs before claiming coverage of other behavior.
- For Lua changes, run `stylua --check <changed-lua-files>` and an appropriate
  syntax/load check. Report unavailable tools or dependencies explicitly.
- A headless startup check does not prove lazy-loaded plugins ran. Exercise the
  affected trigger or command when practical and state what was actually loaded.
- Terminal key delivery, clipboard integration, focus events, and visual behavior
  need interactive verification. Distinguish this from headless checks.
- When running Neovim checks, use a temporary `XDG_STATE_HOME` to isolate logs and
  state; this does not isolate plugin data, downloads, or all startup side effects.
- Run `git diff --check` before finishing; for staged changes also run
  `git diff --cached --check`.

## Plugin lock file and helper commands

- `just update_plugins` stages `lazy-lock.json` and creates a commit. It is not a
  validation command and does not itself download plugin updates.
- Change `lazy-lock.json` only when the requested work includes plugin version
  changes; preserve any pre-existing modifications.
- Keep generated logs such as `nvim.log` out of commits.
