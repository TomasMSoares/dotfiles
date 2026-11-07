# Project picker (fzf + zoxide)

**Status:** plan, not implemented

## Problem

Each project gets its own tmux session. Getting to a project still means
`cd`-ing there and running `tmux new -s <name>`, or remembering which sessions
exist. `prefix f` / `prefix s` (tmux's `choose-tree`) only lists sessions that
are already running, so it can't open a new one.

## Idea

`prefix f` opens a popup with every project in one list:

```
┌─ projects ─────────────────────────────────────┐
│ > quan                                         │
│ ● QuantumSim          ~/source/QuantumSim      │   ● = session already running
│   quantum-hw          ~/TUM/Master/2FS/...     │
│   dotfiles            ~/dotfiles               │
└────────────────────────────────────────────────┘
```

- Type a few letters and fzf narrows the list.
- **Enter:** switch to the project's session if it exists. Otherwise create a
  session in that folder, named after it, and switch to it.
- **Esc:** cancel.
- **Ctrl-x:** kill the highlighted project's session.

The same script also works as a shell command (e.g. `t`). Run outside tmux, it
attaches instead of switching.

## Where the list comes from

The script merges three sources and removes duplicates:

1. **Running tmux sessions** (`tmux list-sessions`), listed first and marked `●`.
2. **zoxide's frecent folders** (`zoxide query -l`). Projects you use often rise
   to the top without any setup.
3. **Git repos under the project roots** (`fd -H -t d '^\.git$' --max-depth 4`
   over `~/source`, `~/TUM` and `~/dotfiles`). New clones appear before you've
   ever visited them.

## Implementation sketch

- A ~40-line bash script, `scripts/tmux-sessionizer`, built on `fzf`, `zoxide`,
  `fd` and `tmux`.
- Session name: the folder's basename, with `.` and `:` replaced by `_` (tmux
  doesn't allow those characters in session names).
- Inside tmux: `tmux switch-client -t <name>`. Outside: `tmux attach -t <name>`.
- tmux binding, replacing the current `choose-tree` fallback:

  ```tmux
  bind f display-popup -E -w 60% -h 60% "tmux-sessionizer"
  ```

- Optional shell alias in `.zshrc`: `alias t='tmux-sessionizer'`.

## How it fits the rest

| Key | Moves between |
|---|---|
| `prefix f` | projects (sessions) |
| `Alt-1..9` | windows inside the current project |
| `prefix a` | agent windows across all projects |

## Open decisions

- [ ] Own script (fully readable and editable) or [sesh](https://github.com/joshmedeski/sesh)
      (a finished tool with its own config).
- [ ] Project roots to scan: `~/source`, `~/TUM`, `~/dotfiles`, anything else?
- [ ] Layout of a new session: a plain shell, or `1 nvim` + `2 shell`?
