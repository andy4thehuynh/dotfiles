#!/bin/bash

# Remove recently opened applications from dock
defaults write com.apple.dock show-recents -bool false
killall Dock
