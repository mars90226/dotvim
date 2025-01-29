#!/bin/bash
# generate fzf preview command with bat
# require fzf 0.18.0 & bat 0.10.0
# Usage: generate_fzf_preview_with_bat.sh preview_offset [file]

calculate_preview_vars() {
  local preview_offset="$1"

  # Calculations referencing fzf variables
  local current_line="\$(( {n} + $preview_offset ))"
  local original_preview_start="\$(( {n} + $preview_offset - \$FZF_PREVIEW_LINES / 2 ))"
  local original_preview_end="\$(( {n} + $preview_offset + \$FZF_PREVIEW_LINES / 2 ))"
  local preview_start="\"\$([[ $original_preview_start -lt 0 ]] && echo 0 || echo $original_preview_start )\""
  local preview_end="\"\$([[ $original_preview_end -lt \$FZF_PREVIEW_LINES ]] && echo \$LINES || echo $original_preview_end )\""

  printf '%s\n%s\n%s\n' "$current_line" "$preview_start" "$preview_end"
}

calculate_preview_command() {
  local preview_offset="$1"
  local file="$2"

  local preview_command="bat --style=numbers --color=always"

  # Use `mapfile -t` to correctly handle lines (including any embedded spaces).
  mapfile -t preview_vars < <(calculate_preview_vars "$preview_offset")
  current_line="${preview_vars[0]}"
  preview_start="${preview_vars[1]}"
  preview_end="${preview_vars[2]}"

  preview_command+=" --line-range ${preview_start}:${preview_end} --highlight-line ${current_line} ${file}"

  echo "$preview_command"
}

calculate_full_preview_command() {
  local preview_offset="$1"
  local file="$2"
  local pattern="$3"
  local tmp_folder="$4"

  local preview_command full_preview_command

  if [[ -n "${pattern}" ]]; then
    tmp_folder="${tmp_folder:-$(mktemp -d /tmp/fzf_preview.XXXXXX)}"
    mkdir -p "$tmp_folder"
    tmp_file="${tmp_folder}/$(basename "${file}")"

    # escape pattern
    printf -v pattern "%q" "${pattern}"
    filter_command="rg ${pattern} ${file} > \"${tmp_file}\""
    # TODO: Remove tmp_folder after fzf exit
    clean_command="rm \"$tmp_file\""

    preview_command="$(calculate_preview_command "$preview_offset" "$tmp_file")"
    full_preview_command="${filter_command}; ${preview_command}; ${clean_command}"
  else
    preview_command="$(calculate_preview_command "$preview_offset" "$file")"
    full_preview_command="${preview_command}"
  fi

  echo "${full_preview_command}"
}

full_preview_command="$(calculate_full_preview_command "$@")"

echo "${full_preview_command}"

# DEBUG
# echo "echo -e '${preview_start}\n${preview_end}' | fold -w 80"
# echo "echo ${preview_start}:${preview_end}"
