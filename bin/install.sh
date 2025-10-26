#!/bin/zsh

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

brew tap FelixKratz/formulae

## Formulae
echo "Installing Brew Formulae..."
### Essentials
brew install wget
brew install jq
brew install ripgrep
brew install bear
brew install mas
brew install gh
brew install switchaudio-osx
brew install sketchybar
brew install borders
brew install aerospace

### Terminal
brew install neovim
brew install fzf
brew install tmux
brew install zoxide
brew install asdf
brew install nvm

### Nice to have
brew install btop
brew install lazygit

## Casks
echo "Installing Brew Casks..."
### Terminals & Browsers
brew install --cask ghostty
brew install --cask arc

## Nice to have
brew install --cask spotify
brew install --cask figma
brew install --cask slack
brew install --cask zoom

### Fonts
brew install --cask font-jetbrains-mono-nerd-font

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.Finder AppleShowAllFiles -bool true

# Copying and checking out configuration files
echo "Planting Configuration Files..."
[ ! -d "$HOME/.dotfiles" ] && git clone --bare git@github.com:EvanBancroft/.dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout main
