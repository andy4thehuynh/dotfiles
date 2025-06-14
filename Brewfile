require "os"

puts "🚀 Installing packages.."

brew "fd"
brew "fzf"
brew "git"
brew "jq"
brew "jo" # small utility to create JSON objects
brew "neovim"
brew "ripgrep"
brew "tealdeer"

if OS.mac?
  cask "discord"
  cask "docker"
  cask "font-caskaydia-mono-nerd-font"
  cask "font-fira-code-nerd-font"
  cask "font-hack-nerd-font"
  cask "font-meslo-lg-nerd-font"
  cask "font-symbols-only-nerd-font"
  cask "google-chrome"
  cask "slack"
  cask "visual-studio-code"
  cask "zoom"
end

# Homebrew filters env variables and only passes variables prefixed with HOMEBREW_
if ENV['HOMEBREW_EXTRAS']
  puts "⚡ Installing extra packages.."

  brew "docker-compose"
  brew "fabric-ai"
  brew "spotify_player"

  tap "1password/tap"
  cask "1password-cli"
  cask "anki"
  cask "raycast"
  cask "trex"
  cask "warp"
end

if ENV['HOMEBREW_EXPERIMENT']
  tap "FelixKratz/formulae" # for borders
  tap "ngrok/ngrok"

  brew "asciinema" # record and share your terminal sessions,
  brew "git-lfs" # git extension for versioning large files
  brew "borders" # add colored borders to user
  brew "figlet" # making large letters out of ordinary text
  brew "python-setuptools" # download, build, install, upgrade, and uninstall Python packages

  cask "devutils" # all-in-one toolbox for developers
  cask "cursor"
  cask "figma"
  cask "ghostty" # cross-platform terminal emulator that uses platform-native UI and GPU acceleration
  cask "gpg-suite" # tools to protect your emails and files
  cask "obs" # OSS for live streaming and screen recording
  cask "soundsource" # sound and audio controller
  cask "ngrok" # expose a local server to the internet 
end
