local plugin_utils = require('vimrc.plugin_utils')

local cli = {}

cli.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  -- sdcv
  if vim.fn.executable('sdcv') == 1 then
    use_config {
      'mars90226/cli-sdcv',
      config = function()
        nnoremap('<Leader>sd', [[:execute vimrc#utility#get_sdcv_command() . ' ' . expand('<cword>')<CR>]])
        xnoremap('<Leader>sd', [[:<C-U>execute vimrc#utility#get_sdcv_command() . " '" . vimrc#utility#get_visual_selection() . "'"<CR>]])
        nnoremap('<Space>sd',  [[:call vimrc#utility#execute_command(vimrc#utility#get_sdcv_command(), 'sdcv: ')<CR>]])
      end
    }
  end

  -- translate-shell
  if vim.fn.executable('trans') == 1 then
    use_config {
      'mars90226/cli-trans',
      config = function()
        nnoremap('<Leader><C-K><C-K>', [[:execute vimrc#utility#get_translate_shell_command() . ' ' . expand('<cword>')<CR>]])
        xnoremap('<Leader><C-K><C-K>', [[:<C-U>execute vimrc#utility#get_translate_shell_command() . ' ' . expand('<cword>')<CR>]])
        nnoremap('<Space><C-K><C-K>', [[:call vimrc#utility#execute_command(vimrc#utility#get_translate_shell_command(), 'trans: ')<CR>]])
      end
    }
  end
end

return cli
