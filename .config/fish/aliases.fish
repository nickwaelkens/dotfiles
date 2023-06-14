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

# Reset macOS Dock tile size after accidentally resizing the Dock
alias resetdock="defaults write com.apple.dock tilesize -int 36; killall Dock"

alias gl "git log --all --decorate --oneline --graph"
alias gd "git branch | grep -v "master" | xargs git branch -D"
alias git-delete-merged "git branch --merged | grep -v \"master|main\" >/tmp/merged-branches && \
                           nano /tmp/merged-branches && xargs git branch -d </tmp/merged-branches"