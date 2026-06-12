#!/bin/bash

# Remove recently opened applications from dock
defaults write com.apple.dock show-recents -bool false

# Hide the dock automatically
defaults write com.apple.dock autohide -bool true

# Position dock on the left
defaults write com.apple.dock orientation -string left

killall Dock
