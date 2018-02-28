#!/usr/bin/env bash

workspace="$HOME/Workspace"
projects="$HOME/Projects"

init() {
  set -e

  # Init the homedir repo on this computer.
  init_homedir
  cd

  # Symlink some files into ~
  scaffold_homedir

  # Install homebrew
  install_homebrew

  # Use bundle to install the Brewfile.
  brew_bundle

#  if ! hash xcodebuild 2>/dev/null; then
#    echo "You must install XCode to continue." 1>&2;
#    read -p "Press enter when done."
#  fi
#
#  # Accept XCode license
#  echo "Please enter your administrator password to accept the XCode license."
#  sudo xcodebuild -license accept

  # Install oh-my-zsh
  install_oh_my_zsh

  # Sync from DropBox
  dropbox_setup

  finish_up
}

init_homedir() {
  mkdir -p $workspace $projects
  cd $workspace
  if [[ ! -d $workspace/homedir ]]; then
    git clone https://github.com/q0rban/homedir.git
  fi
  cd homedir
  git pull
}

scaffold_homedir() {
  set +e
  symlinks="bin .gitconfig .zshrc"
  for file in $symlinks; do
    ln -s $workspace/homedir/$file $HOME
  done
  set -e
  echo "Symlinked some version controlled files into ~."
  sudo bash -c "echo $HOME/bin > /etc/paths.d/homebin"
}

install_homebrew() {
  if hash brew; then
    echo "Homebrew already installed. Continuing."
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

brew_bundle() {
  # Make the Brewfile global.
  ln -s $workspace/homedir/Brewfile $HOME/.Brewfile || echo "Global .Brewfile already exists."
  brew bundle --global
}

install_oh_my_zsh() {
  if [[ -d $HOME/.oh-my-zsh/ ]]; then
    echo "oh-my-zsh already installed. Continuing."
  else
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ln -sf $workspace/homedir/oh-my-zsh/custom $HOME/.oh-my-zsh
    echo "oh-my-zsh installed with custom config."
  fi
  sudo bash -c 'grep /usr/local/bin/zsh /etc/shells ||
    echo "/usr/local/bin/zsh" >> /etc/shells &&
    echo "Added /usr/local/bin/zsh to /etc/shells."'
  chsh -s /usr/local/bin/zsh
}

dropbox_setup() {
  while [[ -z "$(find ~ -maxdepth 1 -name 'Dropbox*' -print -quit)" ]]; do
    echo "Unable to find Dropbox folder." 1>&2;
    read -p "Please configure your personal Dropbox account and press enter when done."
  done

  # Symlink DropBox/Syncs/private to homedir.
  printf "Please select the Dropbox folder to use:\n"
  select dropbox_dir in $HOME/Dropbox*; do test -n "$dropbox_dir" && break; echo ">>> Invalid Selection"; done
  mkdir -p "$dropbox_dir/Syncs/private"
  chmod -R go-rwx "$dropbox_dir/Syncs/private"
  ln -s "$dropbox_dir/Syncs/private" $HOME || echo "~/private already exists."
  echo "Synced private files to ~/private."

  # List out other syncs to configure.
  echo "Here are other syncs you may want to configure."
  ls "$dropbox_dir/Syncs" | grep -v private
  read -p "Press enter to continue."
}

finish_up() {
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  pandoc $HOME/private/setup-info.md --from gfm | lynx -stdin
  read -p "Almost done! Press enter to install all software updates and reboot."
  sudo sh -c "softwareupdate -ia && reboot"
}

err_report() {
  echo "Error on line $(caller)" >&2
}

trap err_report ERR

init
