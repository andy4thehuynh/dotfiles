bootstrap::
	ln -vsfn ${PWD}/git/_gitconfig ${HOME}/.gitconfig
	ln -vsfn ${PWD}/git/_gitignore_global ${HOME}/.gitignore_global
	ln -vsfn ${PWD}/config/mise/config.toml ${HOME}/.config/mise/config.toml
	ln -vsfn ${PWD}/config/zsh/_zshrc ${HOME}/.zshrc
	ln -vsfn ${PWD}/config/nvim ${HOME}/.config/nvim
	ln -vsfn ${PWD}/config/nvim.bak ${HOME}/.config/nvim.bak
	brew bundle --cleanup
