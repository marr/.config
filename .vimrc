" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------

set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" Indentation
set cindent
set colorcolumn=81
set hlsearch
set ignorecase
set incsearch
set nocompatible
set relativenumber
"set softtabstop=4          " stick with convention
set smarttab
set shiftwidth=4           " ..
set tabstop=4
set expandtab              " expand tabs to spaces

" Include $ in varibale names
set iskeyword=@,48-57,_,192-255,#,$,-

" Pathogen
execute pathogen#infect()
filetype plugin indent on
syntax enable

" ------------------------------------------------------------------------------
" Andrew Ray's vim-project fork
" ------------------------------------------------------------------------------
" Enable NERDTree integration.
let g:project_use_nerdtree = 1

" Do not show the project browser as a buffer in the buffer list (uses ``nobuflisted``)
let g:project_unlisted_buffer = 1

" Disable the project browsing screen on starting Vim
" let g:project_enable_welcome = 0

" Do not change tab titles to project names
let g:project_disable_tab_title = 1

call project#rc("~/Projects")
Project 'ct/tilt-react-components', 'Tilt React Components (TRC)'
Project 'ct/crowdtilt-internal-api', 'Crowdtilt internal api'
Project 'ct/crowdtilt-public-site', 'Crowdtilt public site'
Project 'ct/site', 'New Site'
Project 'ct/crowdtilt-public-ctiltit', 'tilt.tc shortening'
Project 'ct/crowdtilt-engineering-blog', 'Crowdtilt blog'
Project 'ct/chef', 'Chef (deployment configuration)'
Project 'ct/react-webpack-demo', 'React Webpack Sandbox'
Project 'lolauth', 'OAuth Test App'
Project 'phormat-dancer-server', 'Phormat Dancer App'
Project 'webpack-with-common-libs', 'Webpack with React, Bootstrap, jQuery'
Project '../.config', 'Config / dotfiles'
Project '../src/jquery-validation', 'jQuery validation'
Project '../src/jquery', 'jQuery'

" ------------------------------------------------------------------------------
" Styling
" ------------------------------------------------------------------------------
colorscheme jellybeans
set gfn=MonacoForPowerline:h12
let g:airline_powerline_fonts = 1

let g:syntastic_javascript_checkers = ['jsxhint']

" ------------------------------------------------------------------------------
" Leader
" ------------------------------------------------------------------------------
let mapleader = ","

" Copy current buffer path relative to root of VIM session to system clipboard
nnoremap <Leader>yp :let @*=expand("%")<cr>:echo "Copied file path to clipboard"<cr>
" Copy current filename to system clipboard
nnoremap <Leader>yf :let @*=expand("%:t")<cr>:echo "Copied file name to clipboard"<cr>
" Copy current buffer path without filename to system clipboard
nnoremap <Leader>yd :let @*=expand("%:h")<cr>:echo "Copied file directory to clipboard"<cr>

" ------------------------------------------------------------------------------
"  Plugin Ctrl-p
" ------------------------------------------------------------------------------
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0

" Unset cap of 10,000 files so we find everything
let g:ctrlp_max_files = 0

" Tell Ctrl-P to keep the current VIM working directory when starting a
" search, another really stupid non default
let g:ctrlp_working_path_mode = 0

" Ctrl-P ignore target dirs so VIM doesn't have to! Yay!
let g:ctrlp_custom_ignore = {
    \ 'dir': '\.git$\|\.hg$\|\.svn$\|target$\|built$\|.build$\|node_modules\|\.sass-cache',
    \ 'file': '\.ttc$',
    \ }

" ------------------------------------------------------------------------------
"  Plugin ack 
" ------------------------------------------------------------------------------
" Visual ack, used to ack for highlighted text
function! s:VAck()
  let old = @"
  norm! gvy
  let @z = substitute(escape(@", '\'), '\n', '\\n', 'g')
  let @" = old
endfunction

" Ack for visual selection
vnoremap <Leader>av :<C-u>call <SID>VAck()<CR>:exe "Ack! ".@z.""<CR>

" Ack for word under cursor
nnoremap <Leader>av :Ack!<cr>
" Open Ack
nnoremap <Leader>ao :Ack! -i

" Code folding with space
nnoremap <Space> za

" Open multiplely selected files in a tab by default
let g:ctrlp_open_multi = '10t'

" delete a line, but only copy a whitespace-trimmed version to " register
nnoremap <Leader>dd _yg_"_dd
nnoremap <Leader>yy _yg_


" ------------------------------------------------------------------------------
" File type customizations. Use tt2* sparingly, they slow down vim considerably
" ------------------------------------------------------------------------------
"au BufRead,BufNewFile *.tt2 setf tt2html
au BufRead,BufNewFile *.js.tt setf tt2js
au BufRead,BufNewFile *.tt setf tt2html
au BufRead,BufNewFile .jshintrc setf javascript

" ------------------------------------------------------------------------------
" Highlight trailing whitespace in vim on non empty lines, but not while typing in insert mode!
" ------------------------------------------------------------------------------
highlight ExtraWhitespace ctermbg=red guibg=Brown
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\S\zs\s\+$/
au InsertEnter * match ExtraWhitespace /\S\zs\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\S\zs\s\+$/

" -----------------------------------------------------------------------------
" 80 Column widths
" -----------------------------------------------------------------------------
highlight ColorColumn ctermbg=red guibg=Brown

" For test files
au BufRead,BufNewFile *.t setfiletype perl
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Relative on focus
au FocusLost * :set number
au FocusGained * :set relativenumber

" Gundo tree viewer
nnoremap <Leader>u :GundoToggle<CR>

" NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>

" opens $HOME/.profile for editing
nnoremap <Leader>e :e $HOME/.profile<CR>

" source $MYVIMRC reloads the saved $MYVIMRC
nnoremap <Leader>s :source $MYVIMRC<CR>

" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>

" * and # search for next/previous of selected text when used in visual mode
vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>
" ------------------------------------------------------------------------------
" Status bar
" ------------------------------------------------------------------------------
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%{fugitive#statusline()}
set statusline+=%=                           " right align
set statusline+=%-10.(%l,%c%V%)\ %<%P        " offset

 function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

" ------------------------------------------------------------------------------
" Git conflicts,  use with bash alias:
"   mvim -c 'call EditConflitedArgs()' \$(git diff --name-only --diff-filter=U)
" ------------------------------------------------------------------------------
function! EditConflictFiles()
    let filter = system('git diff --name-only --diff-filter=U')
    let conflicted = split( filter, '\n')
    let massaged = []

    for conflict in conflicted
        let tmp = substitute(conflict, '\_s\+', '', 'g')
        if len( tmp ) > 0
            call add( massaged, tmp )
        endif
    endfor

    call ProcessConflictFiles( massaged )
endfunction

function! EditConflitedArgs()
    call ProcessConflictFiles( argv() )
endfunction

" Experimental function to load vim with all conflicted files
function! ProcessConflictFiles( conflictFiles )
    " These will be conflict files to edit
    let conflicts = []

    " Read git attributes file into a string
    let gitignore = readfile('.gitattributes')
    let ignored = []
    for ig in gitignore
        " Remove any extra things like -diff (this could be improved to
        " actually use some syntax to know which files ot ignore, like check
        " if [1] == 'diff' ?
        let spl = split( ig, ' ' )
        if len( spl ) > 0
            call add( ignored, spl[0] )
        endif
    endfor

    " Loop over each file in the arglist (passed in to vim from bash)
    for conflict in a:conflictFiles

        " If this file is not ignored in gitattributes (this could be improved)
        if index( ignored, conflict ) < 0

            " Grep each file for the starting error marker
            let cmd = system("grep -n '<<<<<<<' ".conflict)

            " Remove the first line (grep command) and split on linebreak
            let markers = split( cmd, '\n' )

            for marker in markers
                let spl = split( marker, ':' )

                " If this line had a colon in it (otherwise it's an empty line
                " from command output)
                if len( spl ) == 2

                    " Get the line number by removing the white space around it,
                    " because vim is a piece of shit
                    let line = substitute(spl[0], '\_s\+', '', 'g')
                    
                    " Add this file to the list with the data format for the quickfix
                    " window
                    call add( conflicts, {'filename': conflict, 'lnum': line, 'text': spl[1]} )
                endif
            endfor
        endif
        
    endfor

    " Set the quickfix files and open the list
    call setqflist( conflicts )
    execute 'copen'
    execute 'cfirst'

    " Highlight diff markers and then party until you shit
    highlight Conflict guifg=white guibg=red
    match Conflict /^=\{7}.*\|^>\{7}.*\|^<\{7}.*/
    let @/ = '>>>>>>>\|=======\|<<<<<<<'
endfunction

function! FormatJson()
    !silent exec '%s/\v\S+\s*:\s*[^,]*,/\0\r'
    !silent exec '%s/\v\S+\s*:\s*\{/\0\r'
    !silent exec '%s/\v[^{]\zs\},/\r\0'
    normal vie=
    exec 'set ft=javascript'
endfunction

function! FormatPerlObj()
    silent! exec '%s/\v\S+\s*\=\>\s*[^,]*,/\0\r'
    silent! exec '%s/\v\S+\s*\=\>\s*\{/\0\r'
    silent! exec '%s/\v[^{]\zs\},/\r\0'
    normal vie=
    exec 'set ft=perl'
endfunction

function! s:VSetSearch()
    let old = @"
    norm! gvy
    let @/ = '\V' . substitute(escape(@", '\'), '\n', '\\n', 'g')
    let @" = old
endfunction

" Remove non visible buffers
" From http://stackoverflow.com/questions/1534835/how-do-i-close-all-buffers-that-arent-shown-in-a-window-in-vim
function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction
