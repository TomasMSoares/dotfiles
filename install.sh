#!/usr/bin/env bash

# Symlinks the configs in this repo into place. Safe to re-run: links that are
# already correct are left alone, anything else in the way is moved to <path>.bak.<timestamp>.
#
#   ./install.sh            link everything for this OS
#   ./install.sh --dry-run  only show what would change
#   ./install.sh --sddm     also install the sddm theme and config (Linux, needs sudo)

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP=$(date +%Y%m%d-%H%M%S)
DRY_RUN=false
SDDM=false

for arg in "$@"; do
	case "$arg" in
	--dry-run) DRY_RUN=true ;;
	--sddm) SDDM=true ;;
	-h | --help)
		sed -n '3,8p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "Unknown option: $arg (see --help)" >&2
		exit 1
		;;
	esac
done

# Run a command, or only print it with --dry-run
run() {
	if $DRY_RUN; then
		echo "           would run: $*"
	else
		"$@"
	fi
}

# link <path in repo> <target> [sudo]
link() {
	local src="$DOTFILES/$1" dst="$2" sudo="${3:-}"

	if [[ ! -e "$src" ]]; then
		echo "  skip     $1 (not in repo)"
		return
	fi
	if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
		echo "  ok       $dst"
		return
	fi
	if [[ -e "$dst" || -L "$dst" ]]; then
		echo "  backup   $dst -> $dst.bak.$STAMP"
		run $sudo mv "$dst" "$dst.bak.$STAMP"
	fi
	echo "  link     $dst -> $src"
	run $sudo mkdir -p "$(dirname "$dst")"
	run $sudo ln -s "$src" "$dst"
}

echo "Linking dotfiles from $DOTFILES"
$DRY_RUN && echo "(dry run: nothing will be changed)"

echo "Shell & git"
link .zshrc "$HOME/.zshrc"
link .gitconfig "$HOME/.gitconfig"

echo "Terminal & editor"
link ghostty "$CONFIG/ghostty"
link tmux "$CONFIG/tmux"
link nvim "$CONFIG/nvim"
link fastfetch "$CONFIG/fastfetch"
if [[ "$OSTYPE" == "darwin"* ]]; then
	# lazygit ignores ~/.config on macOS unless XDG_CONFIG_HOME is set
	link lazygit "${XDG_CONFIG_HOME:-$HOME/Library/Application Support}/lazygit"
else
	link lazygit "$CONFIG/lazygit"
fi

if [[ "$OSTYPE" != "darwin"* ]]; then
	echo "Desktop (Hyprland)"
	link hypr "$CONFIG/hypr"
	link waybar "$CONFIG/waybar"
	link mako "$CONFIG/mako"
fi

if $SDDM; then
	echo "Login screen (sddm, needs sudo)"
	link sddm/sddm-theme.conf /etc/sddm.conf.d/theme.conf sudo
	# Themes are copied, not linked: the sddm user can't read inside your home folder
	for theme in "$DOTFILES"/sddm/themes/*/; do
		name=$(basename "$theme")
		echo "  copy     sddm/themes/$name -> /usr/share/sddm/themes/$name"
		run sudo mkdir -p "/usr/share/sddm/themes/$name"
		run sudo cp -rT "$theme" "/usr/share/sddm/themes/$name"
	done
fi

# Tools the configs expect (not installed by this script)
missing=()
for cmd in zsh git nvim tmux ghostty lazygit delta fzf zoxide wt jq rg fd; do
	command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if ((${#missing[@]})); then
	echo
	echo "Missing tools: ${missing[*]}"
fi

echo
echo "Checks"

# Print a path with $HOME shortened to <prefix> (portable to macOS's bash 3.2)
short() {
	if [[ "$1" == "$HOME"* ]]; then echo "${2:-~}${1#"$HOME"}"; else echo "$1"; fi
}

# Scripts (git-done, tmux-agent-state, ...) must be on PATH
scripts="$DOTFILES/scripts"
if [[ ":$PATH:" == *":$scripts:"* ]]; then
	echo "  ✓ $(short "$scripts") is in PATH"
else
	# shellcheck disable=SC2016 # print a literal $HOME for copy-pasting
	shown=$(short "$scripts" '$HOME')
	echo "  ⚠ $(short "$scripts") is not in PATH. Add it in your shell's startup file, e.g."
	echo "      zsh,  in ~/.zshrc:                path=(\"$shown\" \$path)"
	echo "      bash, in ~/.bashrc or ~/.profile: export PATH=\"$shown:\$PATH\""
	echo "    (this repo's .zshrc already does it, so a new zsh shell may be enough)"
fi

# Claude Code hooks that drive the tmux agent dots (reference copy: claude/hooks.json)
settings="$HOME/.claude/settings.json"
if ! command -v jq >/dev/null; then
	echo "  ⚠ jq not installed, can't check the Claude Code hooks in $(short "$settings")"
elif [[ ! -f "$settings" ]]; then
	echo "  ⚠ $(short "$settings") not found. Copy the hooks from claude/hooks.json into it"
else
	missing_hooks=$(jq -r --slurpfile want "$DOTFILES/claude/hooks.json" '
		($want[0].hooks | keys) - [(.hooks // {}) | to_entries[]
			| select([.value[].hooks[]?.command] | any(test("tmux-agent-state"))) | .key]
		| join(", ")' "$settings")
	if [[ -z "$missing_hooks" ]]; then
		echo "  ✓ Claude Code hooks set up in $(short "$settings")"
	else
		echo "  ⚠ $(short "$settings") is missing the tmux-agent-state hooks for: $missing_hooks"
		echo "    Add them from claude/hooks.json (merge into the existing \"hooks\" object)"
	fi
fi
