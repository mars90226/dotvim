local plugin_utils = require("vimrc.plugin_utils")

local cli = {}

cli.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  -- sdcv
  if vim.fn.executable("sdcv") == 1 then
    use_config({
      "mars90226/cli-sdcv",
      config = function()
        vim.keymap.set("n", "<Leader>sd", [[:execute vimrc#utility#get_sdcv_command() . ' ' . expand('<cword>')<CR>]])
        vim.keymap.set("x", 
          "<Leader>sd",
          [[:<C-U>execute vimrc#utility#get_sdcv_command() . " '" . vimrc#utility#get_visual_selection() . "'"<CR>]]
        )
        vim.keymap.set("n", "<Space>sd", [[:call vimrc#utility#execute_command(vimrc#utility#get_sdcv_command(), 'sdcv: ')<CR>]])
      end,
    })
  end

  -- translate-shell
  if vim.fn.executable("trans") == 1 then
    use_config({
      "mars90226/cli-trans",
      config = function()
        vim.keymap.set("n", 
          "<Leader><C-K><C-K>",
          [[:execute vimrc#utility#get_translate_shell_command() . ' ' . expand('<cword>')<CR>]],
          { desc = "Translate current word" })
        vim.keymap.set("x", 
          "<Leader><C-K><C-K>",
          [[:<C-U>execute vimrc#utility#get_translate_shell_command() . " '" . vimrc#utility#get_visual_selection() . "'"<CR>]],
          { desc = "Translate selected word" })
        vim.keymap.set("n", 
          "<Space><C-K><C-K>",
          [[:call vimrc#utility#execute_command(vimrc#utility#get_translate_shell_command(), 'trans: ')<CR>]],
          { desc = "Translate input word" })
      end,
    })
  end

  if vim.fn.executable("tmux") == 1 then
    use_config({
      "mars90226/cli-tmux",
      config = function()
        vim.api.nvim_create_user_command("RefreshDisplay", [[call vimrc#utility#refresh_display()]], {})
        vim.api.nvim_create_user_command("RefreshSshClient", [[call vimrc#utility#refresh_ssh_client()]], {})
      end,
    })

    if vim.fn.executable("ssh-agent") == 1 then
      use_config({
        "mars90226/cli-tmux-ssh-agent",
        config = function()
          vim.api.nvim_create_user_command("RefreshSshAgent", [[call vimrc#utility#refresh_ssh_agent()]], {})
        end,
      })
    end
  end

  -- Execute
  if vim.fn["vimrc#plugin#check#get_os"]() == "windows" then
    -- Win32
    use_config({
      "mars90226/cli-execute-windows",
      config = function()
        vim.keymap.set("n", "<Leader>xo", [[<Cmd>lua require("vimrc.windows").execute_current_file()<CR>]])
        vim.keymap.set("n", "<Leader>X", [[<Cmd>lua require("vimrc.windows").open_terminal_in_current_file_folder()<CR>]])
        vim.keymap.set("n", "<Leader>E", [[<Cmd>lua require("vimrc.windows").reveal_current_file_folder_in_explorer()<CR>]])
      end,
    })
  else
    -- Linux
    if vim.fn.executable("xdg-open") == 1 then
      use_config({
        "mars90226/cli-execute-xdg-open",
        config = function()
          vim.keymap.set("n", "<Leader>xo", [[execute vimrc#utility#get_xdg_open() . ' ' . expand('%:p')<CR>]])
        end,
      })
    end
  end

  -- grepprg
  if vim.fn.executable("rg") == 1 then
    use_config({
      "mars90226/cli-grepprg-rg",
      config = function()
        vim.go.grepprg = "rg --vimgrep --no-heading"
        vim.go.grepformat = "%f:%l:%c:%m,%f:%l:%m"
      end,
    })
  elseif vim.fn.executable("ag") == 1 then
    use_config({
      "mars90226/cli-grepprg-ag",
      config = function()
        vim.go.grepprg = "ag --nogroup --nocolor"
      end,
    })
  else
    use_config({
      "mars90226/cli-grepprg-grep",
      config = function()
        vim.go.grepprg = "grep -nH $*"
      end,
    })
  end
end

return cli
