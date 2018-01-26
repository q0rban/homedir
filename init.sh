#!/bin/bash -e

init() {
  workspace="~/Workspace"
  projects="~/Projects"

  mkdir -p $workspace $projects
  cd $workspace
  git clone git@github.com:q0rban/homedir.git
  cd ~

  # Symlink some files into ~
  symlinks="bin .gitconfig"
  for file in $symlinks; do
    ln -s $workspace/homedir/$file ~
  done
  echo "Symlinked some version controlled files into ~."

  # Accept XCode license
  echo "Please enter your administrator password to accept the XCode license."
  sudo xcodebuild -license accept

  # Install homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew bundle --file=$workspace/homedir/Brewfile

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  ln -sf $workspace/homedir/oh-my-zsh/custom ~/.oh-my-zsh
  echo "Symlinked custom .oh-my-zsh in."

  # Sync from DropBox
  while [[ -z "$(find ~ -maxdepth 1 -name 'Dropbox*' -print -quit)" ]]; do
    echo "Unable to find Dropbox folder." 1>&2;
    read -p "Please configure your personal Dropbox account and press enter when done."
  done

  # Symlink DropBox/Syncs/private to homedir.
  printf "Please select the Dropbox folder to use:\n"
  select dropbox_dir in ~/Dropbox*; do test -n "$d" && break; echo ">>> Invalid Selection"; done
  ln -s $dropbox_dir/Syncs/private ~
  echo "Synced private files to ~/private."

  # List out other syncs to configure.
  echo "Here are other syncs you may want to configure."
  ls $dropbox_dir/Syncs | grep -v private
  read -p "Press enter to continue."
}

err_report() {
  echo "Error on line $(caller)" >&2
}

trap err_report ERR

init
