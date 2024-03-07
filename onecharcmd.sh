alias q='exit'
alias f='fzf'
alias l='ls -lha'
function p() {
	__current_proxy=$(gsettings get org.gnome.system.proxy mode)
	if [ "$__current_proxy" = "'manual'" ]; then
		gsettings set org.gnome.system.proxy mode none
		if [ $? -eq 0 ]; then
			echo "Closed proxy for system successfully!"
			return 0
		else
			echo "Closed proxy for system failed!"
			return 1
		fi
	elif [ "$__current_proxy" = "'none'" ]; then
		gsettings set org.gnome.system.proxy mode manual
		if [ $? -eq 0 ]; then
			echo "Opened proxy for system successfully!"
			return 0
		else
			echo "Opened proxy for system failed!"
			return 1
		fi
	else
		echo "Unknown mode:$__current_proxy"
		return 1
	fi
	return 0
}
function t() {
	if [[ -z $(which tmux) ]]; then
		echo "Did not install tmux"
		return 1
	fi
	__tmux_ls=$(tmux ls)
	if [ $? -ne 0 ]; then
		tmux
		return $?
	fi
	__tmux_ls=$(tmux ls | awk -F ':' '{print $1}' | nl)
	__tmux_ls_count=$(echo "$__tmux_ls" | grep -c .)
	if [ $__tmux_ls_count -eq 1 ]; then
		tmux attach
		return 0
	fi
	echo "There is mutiple sessions, input number to choose"
	echo "$__tmux_ls" | column -t
	read __number
	if [[ -z $__number ]]; then
		__number=1
	fi
	tmux attach $(echo __tmux_ls | grep "^$__number	" | awk -F '	' '{print $2}')
	return $?
}
function v() {
	if [[ -z $(which nvim) ]]; then
		echo "Neovim not installed!"
		return 1
	fi
	if [[ -z "$1" ]]; then
		nvim
		return 0
	fi
	if test -f "$1"; then
		nvim $1
		return 0
	fi
	if test -d "$1"; then
		if [[ ! -z $(which zoxide) ]]; then
			zoxide add $1
		fi
		nvim $1
		return 0
	fi
	if [[ ! -z $(which zoxide) ]]; then
		for knownpath in $(zoxide query -l); do
			if test -f $knownpath/$1; then
				if [[ $(file $knownpath/$1) =~ "text" ]]; then
					zoxide add $knownpath
					nvim $knownpath/$1
					return 0
				fi
			fi
		done
	fi
	if test -f $HOME/$1; then
		if [[ $(file $HOME/$1) =~ "text" ]]; then
			nvim $HOME/$1
			return 0
		fi
	fi
	if [[ ! -z $(which zoxide) ]]; then
		filepath=$(zoxide query $1)
		if [[ $? == 0 ]]; then
			zoxide add $filepath
			nvim $filepath
			return 0
		fi
	fi
	if [[ ! -z $(which fzf) ]]; then
		filename=$(fzf -f $1)
		if [[ -n $filename ]]; then
			filename=$(fzf -q $1)
			if [[ -n $filename ]]; then
				if test -f $filename; then
					zoxide add $(dirname $filename)
				fi
				if test -d $filename; then
					zoxide add $filename
				fi
				nvim $filename
				return 0
			fi
		fi
	fi
	return 1
}
