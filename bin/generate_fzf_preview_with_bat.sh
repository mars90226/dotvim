#/bin/bash

file="$1"
preview_top="$2"
fzf_preview_command='bat --style=numbers --color=always'
current_line="\$(({n} + $preview_top))"
original_preview_start="\$(({n} + $preview_top - \$LINES / 2))"
preview_start="\"\$([[ $original_preview_start -lt 0 ]] && echo 0 || echo $original_preview_start )\""
original_preview_end="\$(({n} + $preview_top + \$LINES / 2))"
preview_end="\"\$([[ $original_preview_end -lt \$LINES ]] && echo \$LINES || echo $original_preview_end)\""
preview_command="${fzf_preview_command} ${file} --line-range ${preview_start}:${preview_end} --highlight-line ${current_line}"

echo $preview_command

# DEBUG
# echo "echo -e '${preview_start}\n${preview_end}' | fold -w 80"
# echo "echo ${preview_start}:${preview_end}"
