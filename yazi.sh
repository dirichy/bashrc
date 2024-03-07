if [[ ! -z $(which yazi) ]]; then
	function ya() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			cd $HOME
			cd "$cwd"
		fi
		rm -f -- "$tmp"
	}
fi
