#!/bin/bash

# Declare global variables
    date=$(date '+%Y-%m-%d')
#    logDate=$(date '+%Y%m%d')

# Set volume to 0
    osascript -e "set Volume 0"

# Get Mac Dotfiles
    echo "Installing dotfiles"
    # .bash_profile
        curl -sS -O https://raw.githubusercontent.com/DIWesser/mac-dotfiles/master/.bash_profile
        mv .bash_profile ~/.bash_profile
        echo ".bash_profile installed"
    # .bashrc
        curl -sS -O https://raw.githubusercontent.com/DIWesser/mac-dotfiles/master/.bashrc
        mv .bashrc ~/.bashrc
        echo ".bashrc installed"
    # .vimrc
        curl -sS -O https://raw.githubusercontent.com/DIWesser/mac-dotfiles/master/.vimrc
        mv .vimrc ~/.vimrc
        echo ".vimrc installed"

# Check if you have done this before
#if [[ ~/Library/Application\ Support/com.diwesser.school-mac-setup/lastrun >= $logDate ]] ; then
    # Install apps from thumb drive
    # iTerm
        echo "Installing iTerm2"
        cp -r /Volumes/TO\ GO/iTerm.app ~/Applications/iTerm.app

    # Install apps from websites

    # KeePassXC
        echo "Installing KeePassXC"
        # Get version number from homebrew
        keepassxcVersion=$(curl -sS https://raw.githubusercontent.com/caskroom/homebrew-cask/master/Casks/keepassxc.rb | grep "version " | cut -d "'" -f2)
        # Download DMG
        curl -sS -o KeePassXC.dmg -L https://github.com/keepassxreboot/keepassxc/releases/download/$keepassxcVersion/KeePassXC-$keepassxcVersion.dmg
        # Mount DMG
        hdiutil mount KeePassXC.dmg
        # Copy to ~/Applications
        cp -r /Volumes/KeePassXC/KeePassXC.app ~/Applications/KeePassXC.app
        # Unmount DMG
        hdiutil unmount /Volumes/KeePassXC
        # Remove DMG
        rm KeePassXC.dmg
        echo KeePassXC Installed""

    # Typora
        echo "Installing Typora"
        # Download DMG
        curl -sS -O https://typora.io/download/Typora.dmg
        # Mount DMG
        hdiutil mount Typora.dmg
        # Copy ~/Applications
        cp -r /Volumes/Typora/Typora.app ~/Applications/Typora.app
        # Unmount Typora DMG
        hdiutil unmount /Volumes/Typora
        # Remove DMG
        rm Typora.dmg
        echo "Typora Installed"

    # Log run date
#    echo "$logDate" > ~/Library/Application\ Support/com.diwesser.school-mac-setup/lastrun
#fi
# Change default browser to Chrome

# Require password after sleep or screensaver
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

# Finder
    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Show all file extensions
    /usr/bin/defaults write com.apple.finder AppleShowAllExtensions -bool YES
    # Show/hide icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    # Home dir as default finder location
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Maximize autodisplay/hide speed of Dock
    defaults write com.apple.dock autohide-time-modifier -int 0
    # Automatically hide and show the Menu Bar
    defaults write NSGlobalDomain _HIHideMenuBar -bool true
    # Dark Dock
    defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Misc.
    # Use plain text mode for new TextEdit documents
    defaults write com.apple.TextEdit RichText -int 0
    # Open and save files as UTF-8 in TextEdit
    defaults write com.apple.TextEdit PlainTextEncoding -int 4
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

killall Dock
killall Finder

# Open extension web pages
    # HTTPS Everywhere
    open -a"Google Chrome" https://chrome.google.com/webstore/detail/gcbommkclmclpchllfjekcdonpmejbdp
    # Vimium
    open -a"Google Chrome" https://chrome.google.com/webstore/detail/dbepggeogbaibhgnhhndojpepiihcmeb
    # uBlock Origin
    open -a"Google Chrome" https://chrome.google.com/webstore/detail/cjpalhdlnbpafiamejdnhcphjbkeiagm
    # New Tab Redirect
    open -a"Google Chrome" https://chrome.google.com/webstore/detail/icpgjfneehieebagbmdbhnlpiopdcmna
    # Mercury Reader
    open -a"Google Chrome" https://chrome.google.com/webstore/detail/oknpjjbmpnndlpmnhmekjpocelpnlfdi

# Open Workspace
# Journalism School
if [[ $(whoami) = dn* ]] ; then
    # JOUR 2700
    if [[ $(date '+%A') == Monday || $(date '+%A') == Wednesday ]] ; then
	class="JOUR 2700"
    fi

    # JOUR 2702
    if [[ $(date  '+%A') == Tuesday || $(date '+%A') == Thursday ]] ; then
	class="JOUR 2702"
    fi

    # Both
        open /Volumes/To\ GO/DIW\ database.kdbx
        classNotes="/Volumes/TO GO/$date $class.md"
        # Create and open notes
        touch "$classNotes" # make note file
        echo "$date  " >> "$classNotes"
        echo "$class  " >> "$classNotes"
        sleep 1 # Make sure new file will be found
        open -a Typora "$classNotes"
fi
# Computer Science
if [[ $(whoami) = w* ]] ; then
    open -a "iTerm"
    open -a "Google Chrome" https://dal.brightspace.com/d2l/login
fi

echo "Installation complete. Restart terminal windows to use .bash_profile."
