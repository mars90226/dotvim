#!/bin/bash
# generate fzf preview command with bat
# require fzf 0.18.0 & bat 0.10.0
# Usage: generate_fzf_preview_with_bat.sh preview_top [file]

preview_top="$1"
file="$2"
pattern="$3"
tmp_folder="$4"
fzf_preview_command='bat --style=numbers --color=always'
current_line="\$(({n} + $preview_top))"
original_preview_start="\$(({n} + $preview_top - \$FZF_PREVIEW_LINES / 2))"
preview_start="\"\$([[ $original_preview_start -lt 0 ]] && echo 0 || echo $original_preview_start )\""
original_preview_end="\$(({n} + $preview_top + \$FZF_PREVIEW_LINES / 2))"
preview_end="\"\$([[ $original_preview_end -lt \$FZF_PREVIEW_LINES ]] && echo \$LINES || echo $original_preview_end)\""

if [[ -n "${pattern}" ]]; then
  tmp_folder="${tmp_folder:-$(mktemp -d /tmp/fzf_preview.XXXXXX)}"
  tmp_folder="${tmp_folder:-/tmp}" # if mktemp failed

  if [[ ! -d "${tmp_folder}" ]]; then
    mkdir -p "${tmp_folder}"
  fi

  tmp_file="${tmp_folder}/$(basename "${file}")"

  # escape pattern
  printf -v pattern "%q" "${pattern}"
  filter_command="rg ${pattern} ${file} > ${tmp_file}"
  # TODO: Remove tmp_folder after fzf exit
  clean_command="rm ${tmp_file}"

  preview_command="${filter_command}; ${fzf_preview_command} --line-range ${preview_start}:${preview_end} --highlight-line ${current_line} ${tmp_file}; ${clean_command}"
else
  preview_command="${fzf_preview_command} --line-range ${preview_start}:${preview_end} --highlight-line ${current_line} ${file}"
fi

echo $preview_command

# DEBUG
# echo "echo -e '${preview_start}\n${preview_end}' | fold -w 80"
# echo "echo ${preview_start}:${preview_end}"
