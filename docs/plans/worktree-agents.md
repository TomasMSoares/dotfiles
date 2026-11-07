# Worktree + agent windows (`prefix w`)

**Status:** plan, not implemented

## Problem

Two agents working in the same checkout overwrite each other's files and fight
over the branch. Running several agents on one project means giving each one
its own copy of the repo.

## Idea

A **git worktree** is an extra checkout of the same repo, in its own folder and
on its own branch, sharing the same `.git`. One worktree per agent task means
the agents never touch each other's files.

`prefix w` asks for a branch name. It then:

1. creates the branch and its worktree (or reuses them if they already exist),
2. opens a new tmux window named after the branch, inside that worktree,
3. starts `claude` there.

```
 dotfiles │  1 nvim   2 ●fix-auth   3 ●feat-api                        14:32
```

From there:

- The status-bar dots already work. Any `claude` running in a tmux window
  reports its state through `scripts/tmux-agent-state`.
- `prefix g` opens lazygit and `prefix e` opens nvim **in that worktree**,
  because popups and splits start in the pane's current folder.
- Splits (`prefix v` / `prefix -`) also open inside the worktree.

## Tool: worktrunk (`wt`)

Already installed. It addresses worktrees by branch name, which suits this
workflow:

| Command | Does |
|---|---|
| `wt switch -c <branch> -x claude` | create branch + worktree, start Claude in it |
| `wt switch <branch>` | go to an existing worktree |
| `wt list` | all worktrees with their status |
| `wt merge` | merge the current branch into the target branch |
| `wt remove` | remove the worktree (and the branch, if merged) |

It also supports hooks that run on create, e.g. copying `.env` or installing
dependencies. See `wt hook --help` and `wt config --help`.

## Implementation sketch

- Script `scripts/tmux-agent <branch> [command]`:
  - Find the main repo from the current pane's folder (`git worktree list`,
    first entry).
  - `tmux new-window -n <branch> -c <repo> "wt switch -c <branch> -x claude"`.
    `-x` starts Claude inside the worktree, so later splits inherit that folder.
  - If the branch already exists, drop `-c` and reuse the worktree.
  - Optionally fall back to a shell in the worktree when Claude exits, so the
    window doesn't close.
- tmux bindings:

  ```tmux
  bind w command-prompt -p "branch:" "run-shell 'tmux-agent %%'"
  # cleanup: remove the current window's worktree and close the window
  bind W confirm-before -p "remove worktree #W? (y/n)" "run-shell 'tmux-agent --remove #W'"
  ```

  `prefix w` replaces tmux's default window picker, which `prefix f` and
  `prefix a` already cover.

## Reviewing an agent's work

1. `Alt-<n>` to the agent's window. The dot says whether it's done.
2. `prefix g` to read and stage the diff in lazygit (uses delta).
3. Optional: `diffview.nvim` with `:DiffviewOpen main...HEAD` to see the whole
   branch against main as side-by-side diffs.
4. `wt merge`, then `prefix W` to clean up.

## Alternatives considered

- `claude -w <name>`: Claude Code's own worktrees, created under
  `.claude/worktrees/`. Splits and popups in that window would still start in
  the main repo, not the worktree.
- `claude --worktree --tmux`: creates a separate tmux *session* per worktree,
  not a window inside the project's session.

## Open decisions

- [ ] Where worktrees live: worktrunk's default (check `wt config show`) or e.g.
      `../<repo>.worktrees/<branch>`.
- [ ] What happens when Claude exits: close the window, or keep a shell there.
- [ ] Whether `prefix W` should also delete the branch, or leave that to
      `wt remove` / `wt merge`.
- [ ] Add `diffview.nvim` for reviewing.
