" Settings
function! vimrc#any_jump#settings() abort
  nnoremap <silent><buffer> S :call g:AnyJumpHandleOpen('split')<CR><C-W>r
  nnoremap <silent><buffer> V :call g:AnyJumpHandleOpen('vsplit')<CR><C-W>r

  call vimrc#any_jump#extend_ui(t:any_jump)
endfunction

function! vimrc#any_jump#extend_ui(any_jump) abort
  let a:any_jump.RenderUi = function('vimrc#any_jump#render_ui_extend', [a:any_jump, a:any_jump.RenderUi])
endfunction

function! vimrc#any_jump#render_ui_extend(any_jump, OriginalRenderUi) abort
  call a:OriginalRenderUi()


  " Render custom help
  let color = g:AnyJumpGetColor('help')

  call a:any_jump.AddLine([ a:any_jump.CreateItem('help_text', '', color) ])
  call a:any_jump.AddLine([ a:any_jump.CreateItem('help_link', '> Custom Help', g:AnyJumpGetColor('heading_text')) ])
  call a:any_jump.AddLine([ a:any_jump.CreateItem('help_text', '', color) ])

  call a:any_jump.AddLine([ a:any_jump.CreateItem('help_text', '[S] open in rightbelow split  [V] open in rightbelow vsplit', color) ])
endfunction
