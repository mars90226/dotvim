#/bin/bash

# generate fzf preview command with bat
# require fzf 0.18.0 & bat 0.10.0
# Usage: generate_fzf_preview_with_bat.sh preview_top [file]

preview_top="$1"
file="$2"
fzf_preview_command='bat --style=numbers --color=always'
current_line="\$(({n} + $preview_top))"
original_preview_start="\$(({n} + $preview_top - \$FZF_PREVIEW_LINES / 2))"
preview_start="\"\$([[ $original_preview_start -lt 0 ]] && echo 0 || echo $original_preview_start )\""
original_preview_end="\$(({n} + $preview_top + \$FZF_PREVIEW_LINES / 2))"
preview_end="\"\$([[ $original_preview_end -lt \$FZF_PREVIEW_LINES ]] && echo \$LINES || echo $original_preview_end)\""
preview_command="${fzf_preview_command} --line-range ${preview_start}:${preview_end} --highlight-line ${current_line} ${file}"

echo $preview_command

# DEBUG
# echo "echo -e '${preview_start}\n${preview_end}' | fold -w 80"
# echo "echo ${preview_start}:${preview_end}"
