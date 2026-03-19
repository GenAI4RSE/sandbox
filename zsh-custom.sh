# oh-my-zsh plugins and theme (must be set before oh-my-zsh is sourced)
sed -i 's/^plugins=.*/plugins=(git)/' ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' ~/.zshrc

# Custom settings appended to .zshrc
cat >> ~/.zshrc << 'EOF'

# Timestamp format for history
HIST_STAMPS="yyyy-mm-dd"

# autojump
[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh

# uv: ensure PATH and enable shell completions
export PATH="$HOME/.local/bin:$PATH"
eval "$(uv generate-shell-completion zsh 2>/dev/null)"

# Alias
alias bat="batcat"
alias cls='clear'
alias ll='ls -alF'
EOF
