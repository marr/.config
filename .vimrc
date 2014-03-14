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
set softtabstop=2          " stick with convention
set shiftwidth=2           " ..
set tabstop=2
set expandtab              " expand tabs to spaces

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

Project 'angular', 'Angular JS experiments'
Project 'ct/crowdtilt-internal-api', 'Crowdtilt internal api'
Project 'ct/crowdtilt-public-site', 'Crowdtilt public site'
Project 'ct/crowdtilt-public-ctiltit', 'tilt.tc shortening'
Project 'ct/crowdtilt-engineering-blog', 'Crowdtilt blog'
Project 'lolauth', 'OAuth Test App'
Project 'phormat', 'Phormat Bower Component'
Project 'phormat-dancer-server', 'Phormat Dancer App'
Project '../.config', 'Config / dotfiles'
Project '../src/jquery-validation', 'jQuery validation'
Project '../src/jquery', 'jQuery'

" ------------------------------------------------------------------------------
" Styling
" ------------------------------------------------------------------------------
if has("gui_running")
    colorscheme jellybeans
else
    colorscheme solarized
    set background=dark
    set t_Co=16
endif
set gfn=MonacoForPowerline:h12
let g:airline_powerline_fonts = 1

" ------------------------------------------------------------------------------
" Leader
" ------------------------------------------------------------------------------
let mapleader = ","


" ------------------------------------------------------------------------------
"  Plugin Ctrl-p
" ------------------------------------------------------------------------------
" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0

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

" source $MYVIMRC reloads the saved $MYVIMRC
nnoremap <Leader>s :source $MYVIMRC<CR>

" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
nnoremap <Leader>v :e $MYVIMRC<CR>


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
