# Default target - runs bootstrap which depends on check_config
all: bootstrap

# Check if the config directory exists, if not create it
check_config:
	@echo "🤔 Checking for config directory..."
	@CONFIG_DIR=$${XDG_CONFIG_HOME:-$$HOME/.config}; \
	if [ ! -d $$CONFIG_DIR ]; then \
		echo "✅ Creating config directory: $$CONFIG_DIR"; \
		mkdir -p $$CONFIG_DIR; \
	else \
		echo "🔍 Config directory exists: $$CONFIG_DIR"; \
	fi

# Create symlinks and install Homebrew packages
bootstrap: check_config
	echo "🔗 Creating symlinks to ~/.config"
	ln -vsfn ${PWD}/git/_gitconfig ${HOME}/.gitconfig
	ln -vsfn ${PWD}/git/_gitignore_global ${HOME}/.gitignore_global
	ln -vsfn ${PWD}/config/mise/config.toml ${HOME}/.config/mise/config.toml
	ln -vsfn ${PWD}/config/zsh/_zshrc ${HOME}/.zshrc
	ln -vsfn ${PWD}/config/nvim ${HOME}/.config/nvim
	ln -vsfn ${PWD}/config/nvim.bak ${HOME}/.config/nvim.bak
	ln -vsfn ${PWD}/config/vscode/settings.json ${HOME}/Library/Application\ Support/Code/User/settings.json
	echo "💎 Run Brewfile"
	brew bundle
