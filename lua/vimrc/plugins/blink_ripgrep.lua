-- Performance workarounds for blink-ripgrep.nvim.
-- NOTE: These wrap internal modules of blink-ripgrep.nvim, recheck after updating it.

local blink_ripgrep = {}

-- Flags for blink-ripgrep's git grep backend, matching `additional_rg_options` of ripgrep backend.
-- `--max-count` limits matches per file, which reduces the output parsed on every keystroke.
blink_ripgrep.gitgrep_flags = { "--threads=2", "--max-count=10" }

-- NOTE: blink-ripgrep appends `additional_gitgrep_options` after the search pattern because it's
-- meant for pathspecs, so git grep rejects flags there ("option must come before non-option
-- arguments"). Insert flags before the pattern instead.
blink_ripgrep.setup_gitgrep_flags = function()
  local ok, gitgrep_command = pcall(require, "blink-ripgrep.backends.git_grep.gitgrep_command")
  if not ok or gitgrep_command._vimrc_flags_wrapped then
    return
  end

  local get_command = gitgrep_command.get_command
  gitgrep_command.get_command = function(prefix, config)
    local command, err = get_command(prefix, config)
    if command then
      local pattern = prefix .. "[\\w_-]+"
      for i, arg in ipairs(command.command) do
        if arg == pattern then
          for j, flag in ipairs(blink_ripgrep.gitgrep_flags) do
            table.insert(command.command, i + j - 1, flag)
          end
          break
        end
      end
    end
    return command, err
  end
  gitgrep_command._vimrc_flags_wrapped = true
end

local parser_source_pattern = "/blink%-ripgrep/backends/[%w_]+/[%w_]+_parser%.lua$"

local wrap_parser = function(module_name, function_name)
  local ok, parser = pcall(require, module_name)
  if not ok or parser._vimrc_lazy_language then
    return
  end

  local parse = parser[function_name]
  parser[function_name] = function(...)
    local filetype_match = vim.filetype.match
    -- Parsing is synchronous, but only skip calls from the parsers themselves in case that changes.
    vim.filetype.match = function(args, ...)
      if debug.getinfo(2, "S").source:find(parser_source_pattern) then
        return nil
      end
      return filetype_match(args, ...)
    end
    local parse_ok, output = pcall(parse, ...)
    vim.filetype.match = filetype_match
    if not parse_ok then
      error(output, 0)
    end

    for _, file in pairs(output.files) do
      file.language = nil
    end
    return output
  end
  parser._vimrc_lazy_language = true
end

-- NOTE: blink-ripgrep parsers call `vim.filetype.match` (~35µs) for every matched file on every
-- keystroke, which blocks typing for 50-260ms in large repos. The result is only used by the
-- documentation preview, which calls `vim.filetype.match` again anyway. Skip it while parsing and
-- compute the language lazily when an item's documentation is rendered.
blink_ripgrep.setup_lazy_language = function()
  wrap_parser("blink-ripgrep.backends.git_grep.git_grep_parser", "parse_output")
  wrap_parser("blink-ripgrep.backends.ripgrep.ripgrep_parser", "parse")

  local ok, documentation = pcall(require, "blink-ripgrep.documentation")
  if not ok or documentation._vimrc_lazy_language then
    return
  end

  local render = documentation.render_item_documentation
  documentation.render_item_documentation = function(config, draw_opts, file, match)
    if file.language == nil then
      -- Same fallback chain as blink-ripgrep's parsers
      local ext = vim.fn.fnamemodify(file.path, ":e")
      file.language = vim.filetype.match({ filename = file.path })
        or vim.treesitter.language.get_lang(ext or "text")
        or ext
    end
    return render(config, draw_opts, file, match)
  end
  documentation._vimrc_lazy_language = true
end

return blink_ripgrep
