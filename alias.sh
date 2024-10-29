alias bypy='python3 -m bypy'
alias wemeet='/opt/wemeet/wemeetapp.sh'
__matlab_path=$(which matlab)
if [[ ! -z $__matlab_path ]]; then
	function matlab() {
		if [[ -z $SSH_TTY ]]; then
			echo "No ssh session, open with display"
			"$__matlab_path" -nodesktop
			return 0
		else
			echo "Open with ssh session, open with nodisplay"
			"$__matlab_path" -nodesktop -nodisplay
			return 0
		fi
	}
fi
function cd() {
	if [[ -z $(command -v z) ]]; then
		\builtin cd $*
		return $?
	fi
	z $*
	return $?
}
#TODO:finish this function
function cleanbypy() {
	bypyfiles=$(bypy ls temp "\$f \$m" | sed '1d' | awk '{print $1,$2}')
	nowtime=$(date +%s)
	for bypyfile in "$bypyfiles"; do
		set $bypyfile
		filetime=$(echo $2 | sed 's/[,-]//g')
		filetime=$(date -d $filetime +%s)
		echo $filetime
	done
}
