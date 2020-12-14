" Set line wrapping to off to see more error lines in one page
set nowrap
set showmatch

" By default syntax highlighting for each line is limited to 3000 characters
" However, 3000 characters is not sufficient for lengthy C++ errors, so I change it to 20000
set synmaxcol=20000

" Now I define the keywords that I would like them to be highlighted
syn keyword cerrInfo instantiated
syn keyword cerrError error Error ERROR
syn keyword cerrWarning warning Warning WARNING

" -------------------------------------
" In this step I would like to distinguish the prefix in each line (which shows the file name) from the rest of the line
syn region cerrLine start=/^/ end=/\:/
syn region cerrSeparator start=/^\.+/ end=/\./ fold oneline

" I want to make templated type information less visible while debugging
" You have to remember that a type can have nested types. So I define three regions
syn region cerrTemplate1 matchgroup=xBracket1 start=/</ end=/>/ contains=cerrTemplate2 fold oneline
syn region cerrTemplate2 matchgroup=xBracket2 start=/</ end=/>/ contains=cerrTemplate3 fold contained oneline
syn region cerrTemplate3 start=/</ end=/>/ contains=cerrTemplate3 contained oneline fold oneline

" Now I would like to highlight whatever is in parenthesis with a different color so I make
" another region in here. This makes sure that function arguments can have different color
 syn region cerrPar matchgroup=xBracket start=/(/ end=/)/ contains=cerrTemplate1 oneline fold
" GCC puts the real type information in brackets, let's group them separately
 syn region cerrBracket start=/\[/ end=/\]/ contains=cerrTemplate1,cerrPar oneline

" Again GCC puts the error in these weird characters :) So I define a separate region here
syn region cerrCode start=/‘/ end=/’/ contains=cerrPar,cerrBracket,cerrTemplate1 oneline

" And finally I would like to color the line numbers differently
syn match   cerrNum "[0-9]\+[:|,]"

" --------------------------------------------------------------------------
" Now the fun part is here, change the colors to match your terminal colors.
" I Use the following colors for my white background terminal.
" In the following we assign a color for each group that we defined earlier

" Comment is a default VIM color group
highlight link cerrInfo Comment

" We use custom coloring for the rest
highlight default cerrWarning ctermfg=red ctermbg=yellow
highlight default cerrError ctermfg=white ctermbg=red
highlight default cerrLine ctermfg=grey term=bold
highlight default cerrSeparator ctermfg=darkgrey
highlight default cerrTemplate1 ctermfg=grey term=bold
highlight default cerrTemplate2 ctermfg=grey term=bold
highlight default cerrTemplate3 ctermfg=grey
highlight default cerrCode cterm=bold ctermfg=darkgrey
highlight default cerrBracket ctermfg=darkgreen
highlight default xBracket1 ctermfg=darkgrey term=bold
highlight default xBracket2 ctermfg=darkgrey
highlight default cerrPar ctermfg=yellow
highlight default cerrNum ctermfg=red
