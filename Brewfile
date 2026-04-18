require "os"

tap "1password/tap"

puts "🚀 Installing packages.."

tap "FelixKratz/formulae"

brew "bat"
brew "borders"
brew "eza" # ls replacement
brew "fabric-ai"
brew "fd" # find replacement
brew "fzf" # fuzzy finder
brew "gh"
brew "git"
brew "lazydocker"
brew "jq"
brew "neovim"
brew "ripgrep" # grep replacement
brew "starship"
brew "tealdeer" # like tldr
brew "tmuxinator"
brew "zellij"
brew "zoxide" # cd replacement

if OS.mac?
  cask "nikitabobko/tap/aerospace"

  cask "1password-cli"
  cask "anki"
  cask "discord"
  cask "flameshot"
  cask "font-caskaydia-mono-nerd-font"
  cask "font-fira-code-nerd-font"
  cask "font-hack-nerd-font"
  cask "font-meslo-lg-nerd-font"
  cask "font-symbols-only-nerd-font"
  cask "google-chrome"
  cask "kitty"
  cask "raycast"
  cask "slack"
  cask "trex"
  cask "visual-studio-code"
  cask "vivaldi"
  cask "voicenotes"
  cask "zoom"
end

# must install mise via website download due to homebrew issues
