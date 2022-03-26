# Apps… but better
alias ls lsd

# Shortcuts
alias reload! "source ~/.config/fish/config.fish"
alias ... "cd ../.."
alias dl "cd ~/Downloads"
alias dt "cd ~/Desktop"
alias c "cd ~/code"
alias storm="open -a (mdfind -name 'kMDItemFSName==\"*.app\"' -onlyin /Applications/ | grep 'WebStorm.')"
alias pubkey="pbcopy < ~/.ssh/id_ed25519.pub | echo '=> Public key copied to pasteboard.'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
