require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]h'] = { '<Cmd>lua require"gitsigns.actions".next_hunk()<CR>'},
    ['n [h'] = { '<Cmd>lua require"gitsigns.actions".prev_hunk()<CR>'},

    ['n <Leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <Leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <Leader>hu'] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <Leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <Leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <Leader>hR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <Leader>hp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <Leader>hb'] = '<Cmd>lua require"gitsigns".blame_line(true)<CR>',
    ['n <Leader>hS'] = '<Cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <Leader>hU'] = '<Cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 500
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  diff_opts = {
    internal = true,
  },
}
