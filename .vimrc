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
set hlsearch
set ignorecase
set incsearch
set nocompatible
set relativenumber
set softtabstop=4          " stick with convention
set shiftwidth=4           " ..
set tabstop=4
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
Project 'lolauth', 'OAuth Test App'
Project '../src/jquery-validation', 'jQuery validation'
Project '../src', 'Misc. source'

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

" ------------------------------------------------------------------------------
" File type customizations. Use tt2* sparingly, they slow down vim considerably
" ------------------------------------------------------------------------------
"au BufRead,BufNewFile *.tt2 setf tt2html
"au BufRead,BufNewFile *.js.tt setf tt2js
"au BufRead,BufNewFile *.tt setf tt2html
au BufRead,BufNewFile .jshintrc setf javascript

" ------------------------------------------------------------------------------
" Highlight trailing whitespace in vim on non empty lines, but not while typing in insert mode!
" ------------------------------------------------------------------------------
highlight ExtraWhitespace ctermbg=red guibg=Brown
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\S\zs\s\+$/
au InsertEnter * match ExtraWhitespace /\S\zs\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\S\zs\s\+$/

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
