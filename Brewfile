require "os"

puts "🚀 Installing packages.."

brew "fd"
brew "fzf"
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

# Homebrew filters environment variables and only passes through variables that start with HOMEBREW_
if ENV['HOMEBREW_EXTRAS']
  puts "⚡ Installing extra packages.."

  brew "fabric-ai"
  brew "spotify_player"

  tap "1password/tap"
  cask "1password-cli"
  cask "anki"
  cask "raycast"
  cask "trex"
  cask "warp"
end

# Applications you must install manually bc doesn't play nice with Homebrew
#
# Thingsapp - todo mgmt
# Mise - runtime manager
