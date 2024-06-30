source ~/.config/fish/variables.fish
source ~/.config/fish/aliases.fish
source ~/.config/fish/path.fish

# https://github.com/gsamokovarov/jump
jump shell fish | source

# https://github.com/starship/starship
starship init fish | source

# https://github.com/Schniz/fnm
fnm env --use-on-cd | source

gpgconf --launch gpg-agent

# https://atuin.sh
atuin init fish | source
