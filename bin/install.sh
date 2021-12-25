#!/usr/bin/env sh

source ./util.sh

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################

running "checking homebrew..."
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  ok
  bot "Homebrew"
  read -r -p "run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    action "updating homebrew..."
    brew update
    ok "homebrew updated"
    action "upgrading brew packages..."
    brew upgrade
    ok "brews upgraded"
  else
    ok "skipped brew package upgrades."
  fi
fi


# ###########################################################
bot "zsh setup"
# ###########################################################

require_brew zsh

# symslink zsh config
ZSHRC="$HOME/.zshrc"
running "Configuring zsh"
if [ ! -f "ZSHRC" ]; then
  read -r -p "Seems like your zshrc file exist,do you want delete it? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    rm -rf $HOME/.zshrc
    rm -rf $HOME/.zshenv
    action "link zsh/.zshrc and zsh/.zshenv"
    ln -s  $HOME/.dotfile/zsh/zshenv $HOME/.zshenv
    ln -s  $HOME/.dotfile/zsh/zshrc $HOME/.zshrc
  else
    ok "skipped"
  fi
fi

action "Install yabai and skhd"
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
sudo yabai --install-sa
ln -s "$HOME/.dotfile/yabai/yabairc" "$HOME/.yabairc"
ln -s "$HOME/.dotfile/yabai/skhdrc" "$HOME/.skhdrc"
brew services start skhd
brew services start koekeishiya/formulae/yabai

NPMRC="$HOME/.npmrc"
action "Configuring npm"
if [[ ! -f "NPMRC" ]]; then
  read -r -p "Seems like your npmrc file exist,do you want delete it? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    rm -rf $HOME/.npmrc
    action "link npmrc..."
    ln -s "${HOME}/.dotfile/npm/npmrc" "${HOME}/.npmrc"
  fi
fi
