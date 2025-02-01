#!/bin/bash
#
# fzf preview command generator using bat (and optionally rg for filtering)
#
# Requirements:
#   - fzf (>= 0.18.0)   (provides placeholders like {n} and FZF_PREVIEW_LINES)
#   - bat (>= 0.10.0)
#   - rg (ripgrep)     (only needed if you supply a pattern)
#
# Usage:
#   $(basename "$0") preview_offset file [pattern] [tmp_folder]
#
#   preview_offset : A numeric offset added to the current line (fzf's {n})
#   file           : The file to preview
#   pattern        : (Optional) A search pattern used to filter the file with rg
#   tmp_folder     : (Optional) Folder to store temporary files (e.g. Neovim's temporary folder)
#
# Environment Variables:
#   FZF_PREVIEW_LINES : The number of lines available in fzf's preview window.
#

# Exit on error, unset variable use, or pipe failure.
set -euo pipefail

# Display usage information.
usage() {
  cat <<EOF
Usage: $(basename "$0") preview_offset file [pattern] [tmp_folder]

Generate an fzf preview command that uses bat to display a file
with the current line highlighted. If a pattern is provided, the file
will first be filtered using rg.

Requirements:
  - fzf (>= 0.18.0)
  - bat (>= 0.10.0)
  - rg (ripgrep), if pattern filtering is desired.
EOF
  exit 1
}

# Check that required dependencies are installed.
for cmd in bat fzf; do
  command -v "$cmd" >/dev/null || {
    echo "Error: '$cmd' is required but not installed." >&2
    exit 1
  }
done

if [[ $# -lt 2 ]]; then
  usage
fi

# Assign command-line arguments.
preview_offset="$1"
file="$2"
pattern="${3:-}"
tmp_folder="${4:-}"

# If a pattern is provided, ensure rg is available.
if [[ -n "$pattern" ]]; then
  command -v rg >/dev/null || {
    echo "Error: 'rg' (ripgrep) is required for pattern filtering but is not installed." >&2
    exit 1
  }
fi

###############################################################################
# Function: calculate_preview_vars
# Purpose:  Calculate dynamic variables needed to center the preview window
#           around the current line, as provided by fzf.
#
# Uses:
#   - {n}              : fzf placeholder for the current line number.
#   - FZF_PREVIEW_LINES: Environment variable indicating preview window height.
###############################################################################
calculate_preview_vars() {
  local offset="$1"

  # Calculate the "current" line with an offset.
  local current_line="\$(( {n} + ${offset} ))"
  # Calculate the original preview window boundaries.
  local orig_preview_start="\$(( {n} + ${offset} - \$FZF_PREVIEW_LINES / 2 ))"
  local orig_preview_end="\$(( {n} + ${offset} + \$FZF_PREVIEW_LINES / 2 ))"
  # Adjust boundaries to avoid negative values or overflow.
  local preview_start="\"\$([[ ${orig_preview_start} -lt 0 ]] && echo 0 || echo ${orig_preview_start})\""
  local preview_end="\"\$([[ ${orig_preview_end} -lt \$FZF_PREVIEW_LINES ]] && echo \$LINES || echo ${orig_preview_end})\""

  printf '%s\n%s\n%s\n' "$current_line" "$preview_start" "$preview_end"
}

###############################################################################
# Function: calculate_preview_command
# Purpose:  Build the preview command using bat to display a file (or filtered file)
#           with line numbers and a highlighted current line.
###############################################################################
calculate_preview_command() {
  local offset="$1"
  local preview_file="$2"

  # Build the base bat command as an array.
  local -a bat_cmd=("bat" "--style=numbers" "--color=always")
  # Retrieve calculated preview variables.
  mapfile -t preview_vars < <(calculate_preview_vars "$offset")
  local current_line="${preview_vars[0]}"
  local preview_start="${preview_vars[1]}"
  local preview_end="${preview_vars[2]}"

  # Append the options for line range and highlighted line.
  bat_cmd+=(--line-range "${preview_start}:${preview_end}" --highlight-line "${current_line}" "${preview_file}")

  # Output the full command as a single string.
  printf '%s ' "${bat_cmd[@]}"
}

###############################################################################
# Function: calculate_full_preview_command
# Purpose:  Generate the complete command string to be used by fzf as the preview
#           command. If a pattern is provided, first filter the file using rg.
###############################################################################
calculate_full_preview_command() {
  local offset="$1"
  local original_file="$2"
  local search_pattern="${3:-}"
  local work_folder="${4:-}"
  local full_cmd=""

  if [[ -n "$search_pattern" ]]; then
    # Use provided temporary folder or create a new one.
    if [[ ! -d "$work_folder" ]]; then
      work_folder=$(mktemp -d /tmp/fzf_preview.XXXXXX)
    fi

    local tmp_file
    tmp_file="${work_folder}/$(basename "${original_file}")"

    # Escape the search pattern for safe shell usage.
    local escaped_pattern
    printf -v escaped_pattern "%q" "${search_pattern}"
    # Build the filtering command using rg.
    local filter_cmd="rg ${escaped_pattern} \"${original_file}\" > \"${tmp_file}\""
    # Build the bat preview command for the temporary, filtered file.
    local preview_cmd
    preview_cmd=$(calculate_preview_command "$offset" "$tmp_file")
    # Build the cleanup command that removes the temporary file.
    local clean_cmd="rm \"${tmp_file}\""
    # Combine the commands: filter the file, then display the preview, then clean up.
    full_cmd="${filter_cmd}; ${preview_cmd}; ${clean_cmd}"
  else
    # No pattern: use the original file for the preview.
    full_cmd=$(calculate_preview_command "$offset" "$original_file")
  fi

  echo "${full_cmd}"
}

###############################################################################
# Main
###############################################################################
full_preview_command="$(calculate_full_preview_command "$preview_offset" "$file" "$pattern" "$tmp_folder")"
echo "${full_preview_command}"
