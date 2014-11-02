#!/bin/sh

echo "Installing Homebrew..."
if which brew 2>/dev/null 1>/dev/null; then
    echo "Homebrew already installed."
else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing Homebrew software..."

echo "Homebrew: Installing utilities..."

bash .osx_homebrew.bash

echo "Homebrew: Installing Cask apps..."

bash .osx_cask.bash

echo "Homebrew: Installing "fun" Cask apps..."

bash .osx_cask_fun.bash

echo "Finalizing Homebrew configuration..."

brew update
brew upgrade
brew cleanup
brew cask cleanup

echo "Installing python libraries..."

sh python_dependencies.sh

echo "Installing Mjolnir dependencies..."

luarocks install mjolnir.hotkey
luarocks install mjolnir.application

echo "Clearing KeyRemap4MacBook Preferences..."
rm ~/Library/Preferences/org.pqrs.KeyRemap4MacBook.plist

echo "Configuring stow..."
stow -D stow
stow stow

echo "Restowing all apps..."
for dir in */
do
    echo Unstowing $dir
    stow -D $dir
    echo Restowing $dir
    stow $dir
done

echo "Updating submodules..."
git submodule init
git submodule update

echo "Configuring OS X settings..."
bash .osx.bash
