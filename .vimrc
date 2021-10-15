""""""""""""""
" => General "
""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
python3 import os

" Sets how many lines of history VIM has to remember
if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

" This is extremely useful for indenation purposes
" of several filetypes used in web development
" as you can simply press gg=G for auto indentation
if has('autocmd')
  filetype plugin on
  filetype indent on
endif

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

" If a file is modified outside of VIM, read in changes automatically
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null


""""""""""""""
" => Plugins "
""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" improved statusbar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" git integration improvements
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
" file-finding
Plugin 'preservim/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf'
" completion engine
Plugin 'ycm-core/YouCompleteMe'
" linting
Plugin 'vim-syntastic/syntastic'
" syntax highlight improvents
Plugin 'pangloss/vim-javascript'
Plugin 'hdima/python-syntax'
" auto-match brackets/parens
Plugin 'tmsvg/pear-tree'
" highlight maching xml/html tags
Plugin 'Valloric/MatchTagAlways'
" visual indent guides
Plugin 'nathanaelkane/vim-indent-guides'
" auto code formatting
Plugin 'prettier/vim-prettier'
" comment improvements
Plugin 'preservim/nerdcommenter'
" easily wrap/change text surrounds
Plugin 'tpope/vim-surround'
" snippets
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" distraction-free mode
Plugin 'junegunn/goyo.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required


"""""""""""""""""""""""""
" => VIM user interface "
"""""""""""""""""""""""""
" Enable mouse in terminals that support it (gpm)
set mouse=a

" This option speeds up macro execution in Vim
set lazyredraw

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" Show line numbers and relative line numbers
set number
set relativenumber

" Highlight cursor current line and column
set cursorline
set cursorcolumn

" Adjust view when scrolling to show more context
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif


"""""""""""""""""""""""
" => Colors and Fonts "
"""""""""""""""""""""""
" This enabled 256-color support in Vim, which is needed
" by many color schemes
set t_Co=256

" Change Vim's default color scheme
colorscheme deus

" This will enable Vim's syntax highlighting
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif


"""""""""""""""""""""""""""""""""""
" => Text, tab and indent related "
"""""""""""""""""""""""""""""""""""
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

" This will make tabs 4 spaces wide
set tabstop=4

" This is needed to tree tabs as multiple spaces
set shiftwidth=4

" This option will enable you to enter a real Tab character
" by pressing Ctrl-V<Tab>
set expandtab


""""""""""""""""""""""""""
" => Visual mode related "
""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers "
"""""""""""""""""""""""""""""""""""""""""""""""
" This will make Vim start searching the moment you start
" typing the first letter of your search keyword
set incsearch

" This will make Vim highlight all search results that
" matched the search keyword
set hlsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""
" => Editing mappings "
"""""""""""""""""""""""


"""""""""""""""""""""
" => Spell checking "
"""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""
" => Misc "
"""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" dynamically rename tmux window to show current file
if exists('$TMUX')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%:t"))
  autocmd VimLeave * call system("tmux setw automatic-rename")
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif


"""""""""""""""""""""""
" => Helper functions "
"""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


""""""""""""""""""
" => Status line "
""""""""""""""""""
" Always display the status line
set laststatus=2

" Hide mode; this is shown in airline already
set noshowmode


""""""""""""""""""""""
" => Plugin settings "
""""""""""""""""""""""
" This will enable NERDTree to show hidden files
let NERDTreeShowHidden=1
" We'll be using this option to modify files directly
" inside NERDTree inside Vim, without having to exit Vim
set modifiable
" Ignore vim swap files in NERDtree
let NERDTreeIgnore = ['\..*\.swp$']

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" force enable powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16'

" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2

" UltiSnips settings
"let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsExpandTrigger = "<nop>"
inoremap <expr> <CR> pumvisible() ? "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ctrlp settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" vim:set ft=vim et sw=2:
