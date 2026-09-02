fish_add_path ~/go/bin ~/.local/bin ~/.cargo/bin /opt/homebrew/opt/zigup/bin
fish_add_path "$HOME/.bun/bin"
fish_add_path "$HOME/.npm-global/bin"

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx BUN_INSTALL "$HOME/.bun"

if not status is-interactive
  return
end

abbr -a c clear
abbr -a nv nvim
abbr -a vim nvim
abbr -a ga 'git add .'
abbr -a gp 'git push'
abbr -a gcs 'git commit -m'
abbr -a dl yt-dlp
abbr -a sz 'source ~/.config/fish/config.fish'
abbr -a ez 'nvim ~/.config/fish/config.fish'
abbr -a oc opencode
abbr -a lg lazygit
abbr -a rpm repomix
abbr -a pb pbcopy
abbr -a o. 'open .'
abbr -a ju 'jj'

alias ls 'eza --color=always --icons=always --long --git --no-filesize --no-user --no-permissions'
alias l 'eza -lh --icons=auto'
alias ll 'eza -lha --icons=auto --sort=name --group-directories-first'
alias lt 'eza --icons=auto --tree'
alias cdgit 'cd ~/github/'
alias cat 'bat --paging=never --style=plain'
alias mkdir 'mkdir -p'
alias claude 'claude --dangerously-skip-permissions'
alias tbnk 'bun /Users/lilflare/github/interpreter-presentation/language/index.ts'

function accept_and_execute
    commandline -f accept-autosuggestion
    commandline -f execute
end

fzf_configure_bindings --directory=\ef

bind -M insert jk accept-autosuggestion
bind -M insert jj accept_and_execute

bind -M default H beginning-of-line
bind -M default L end-of-line

set -g fish_key_bindings fish_vi_key_bindings

set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one block
set fish_cursor_visual block

starship init fish | source

if command -v zoxide &>/dev/null
    zoxide init fish | source
    alias cd z
end

# opencode
fish_add_path /Users/lilflare/.opencode/bin
