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

# Add private SSH key to Keychain so it's automatically available to ssh.
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

if status is-interactive
    atuin init fish | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Source device-specific config if it exists
test -f ~/.config/fish/local.fish; and source ~/.config/fish/local.fish
