require "os"

tap "1password/tap"

puts "🚀 Installing packages.."

brew "FelixKratz/formulae"

brew "borders"
brew "eza" # ls replacement
brew "fd" # find replacement
brew "fzf" # fuzzy finder
brew "git"
brew "git-lfs" # git extension for versioning large files
brew "lazydocker"
brew "jq"
brew "jo"
brew "ncspot"
brew "neovim"
brew "ripgrep" # grep replacement
brew "sketchybar"
brew "tealdeer" # like tldr
brew "tmuxinator"
brew "zoxide" # cd replacement

if OS.mac?
  cask "nikitabobko/tap/aerospace"

  cask "1password-cli"
  cask "discord"
  cask "font-caskaydia-mono-nerd-font"
  cask "font-fira-code-nerd-font"
  cask "font-hack-nerd-font"
  cask "font-meslo-lg-nerd-font"
  cask "font-symbols-only-nerd-font"
  cask "google-chrome"
  cask "raycast"
  cask "slack"
  cask "visual-studio-code"
  cask "zoom"
end

# Extras are for personal use
if ENV['HOMEBREW_EXTRAS']
  puts "⚡ Installing extra packages.."

  brew "fabric-ai"

  cask "anki"
  cask "trex"
end

# Packages to try out but haven't found the use case
if ENV['HOMEBREW_LABS']
  puts "🧪 Installing labs packages.."

  tap "FelixKratz/formulae" # for borders
  tap "ngrok/ngrok"

  brew "asciinema" # record and share your terminal sessions,
  brew "borders" # add colored borders to user
  brew "figlet" # making large letters out of ordinary text
  brew "python-setuptools" # download, build, install, upgrade, and uninstall Python packages

  cask "cursor"
  cask "devutils" # all-in-one toolbox for developers
  cask "figma"
  cask "ghostty" # cross-platform terminal emulator that uses platform-native UI and GPU acceleration
  cask "gpg-suite" # tools to protect your emails and files
  cask "hyperkey" # convert your caps lock key or any of your modifier keys 
  cask "ngrok" # expose a local server to the internet
  cask "obs" # OSS for live streaming and screen recording
  cask "soundsource" # sound and audio controller
end
