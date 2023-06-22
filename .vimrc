" ============================================================================
" GENERAL {{{
" ============================================================================
set nocompatible              " be iMproved, required
filetype off                  " required

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" If a file is modified outside of VIM, read in changes automatically
set autoread

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

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

let mapleader = "<space>"
let g:mapleader = "<space>"

" vim internal async delay
" frequency for gitgutter updates and swap file saving
set updatetime=100 " ms

" }}}
" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================
" nifty trick to auto-install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'sainnhe/everforest'           " Light & Dark
"Plug 'crusoexia/vim-monokai'        " Dark only
"Plug 'morhetz/gruvbox'              " Light & Dark
"Plug 'NLKNguyen/papercolor-theme'   " Light & Dark

" statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_powerline_fonts = 1
  let g:airline_theme = 'base16'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#ale#enabled = 1

" git things
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" file-finding
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  map <Leader>n :NERDTreeToggle<CR>
  let NERDTreeShowHidden=1
  set modifiable
  let NERDTreeIgnore = ['\..*\.swp$', '.git', '__pycache__']

" tab
Plug 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = '<C-n>'

" syntax highlighting
Plug 'sheerun/vim-polyglot'

" auto-match brackets/parens
Plug 'tmsvg/pear-tree'
  let g:pear_tree_smart_openers = 1
  let g:pear_tree_smart_closers = 1
  let g:pear_tree_smart_backspace = 1

" wrap/change text surrounds
Plug 'tpope/vim-surround'

" comment toggling
Plug 'preservim/nerdcommenter'

" All of your Plugins must be added before the following line
call plug#end()

" }}}
" ============================================================================
" INTERFACE {{{
" ============================================================================
" Enable 256-color support in Vim
set t_Co=256
colorscheme everforest

set mouse=a
set lazyredraw

" Always display the status line
set laststatus=2

" Hide mode; this is shown in airline already
set noshowmode

" Set 7 lines to the cursor when moving vertically
set so=7

set number
set relativenumber

set cursorline
set cursorcolumn

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

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Set spell check highlight
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=red

" }}}
" ============================================================================
" EDITING {{{
" ============================================================================
set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab
set incsearch

set nrformats-=octal

set tabstop=4
set shiftwidth=4
set expandtab

set foldmethod=indent
set foldlevel=99

" Highlight all search results
set hlsearch

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
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

" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================
" Fast saving
nmap <leader>w :w!<cr>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Toggle light/dark mode
nmap <silent> <leader>bg :call ToggleTheme()<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Move between windows easier
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

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Spelling shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Toggle scrollbind
map <leader>sb :windo set scrollbind!<cr>

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" ----------------------------------------------------------------------------
" Toggle light/dark mode
" ----------------------------------------------------------------------------
function! ToggleTheme()
  let is_dark=(&background == 'dark')
  if is_dark
    set background=light
    echo "background -> light"
  else
    set background=dark
    echo "background -> dark"
  endif
endfunction

" ----------------------------------------------------------------------------
" Allow * to search selected text
" ----------------------------------------------------------------------------
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

" ----------------------------------------------------------------------------
" Don't close window, when deleting a buffer
" ----------------------------------------------------------------------------
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

" }}}
" ============================================================================
" vim: set foldmethod=marker foldlevel=0 nomodeline ft=vim sw=2 et:
