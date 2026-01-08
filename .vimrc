" Reminder: you can tell the current setting in vim with "set <commandname>?"

" tabs
set tabstop=4					" display \t as four spaces
set softtabstop=4				" amount of equivalent space the tab key inserts
set shiftwidth=4				" amount of equivalent space >> and << insert/remove
set noexpandtab					" dont convert tabs to spaces

" Set tab and indent settings for Python (PEP 8 Compliance)
" This is same as defaults but good to have it explicit for python
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" appearance
set number					    " line numbers not shown
" set relativenumber			" show relative numbers
" set ruler						" show ruler, not needed due to custom statusline
set cursorline					" highlight current line
" set visualbell				" turn off audible bell
syntax on						" turn on syntax highlighting
set showmatch					" show matching brackets, parens, etc.
set colorcolumn=81				" red column to indicate where the 80 char mark is

" autocomplete
set wildmenu					" enable commandmode autocomplete menu (tab through results)
set wildoptions=pum				" verticle autocomplete menu looks nicer
set wildmode=longest:list,full	" mess with this if autocomplete isn't working how you want it to
let mapleader = ","				" remap the <leader> key from \ for easier typing

" search
set incsearch					" search as characters are entered
set hlsearch					" highlight matches
set ignorecase					" case insensitive search by default

" other
set mouse=a						" enable mouse support in all modes

" filetype stuff
filetype on						" enable filetype detection
filetype plugin on				" load detected filetypes plugin
filetype indent on				" load detected filetypes automatic indenting


" folding
set foldenable          " enable folding (default setting)
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=syntax   " fold based on syntax see https://www.vimfromscratch.com/articles/vim-folding
nnoremap <space> za " space open/closes folds
"mappings to automatically insert matching braces, parens etc...
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

"colorscheme
" to find out what built in colorschemes exist 
" ls /usr/share/vim/vim*/colors | grep vim
" check out https://justinjoyce.dev/every-built-in-vim-color-scheme-with-screenshots/ for visual examples
" go to https://vimcolorschemes.com/i/trending for other cusom schemes
" my fav default schemes are "habamax", "evening", "pablo", "slate"
colorscheme habamax

" statusline
set laststatus=2 	" always show statusline
set noshowmode		" don't show mode status the normal way cause our custom statusline shows it

" Mode segments
"highlight NormalC guifg=#ffffff guibg=#005f87 gui=bold
highlight NormalC guifg=#ffff00 guibg=#5bcffb gui=bold
"highlight InsertC guifg=#ffffff guibg=#5f8700 gui=bold
"highlight VisualC guifg=#ffffff guibg=#d75f00 gui=bold
"highlight ReplaceC guifg=#ffffff guibg=#d7005f gui=bold
"highlight CommandC guifg=#ffffff guibg=#875fd7 gui=bold
"
"" Other segments
highlight Icon guifg=#00d7ff guibg=#000000 gui=bold
"highlight Filename guifg=#ffaf00 guibg=#000000 gui=none
"highlight ReadOnly guifg=#ff5f5f guibg=#000000 gui=bold
"highlight Fileformat guifg=#87d7ff guibg=#000000 gui=none
"highlight Position guifg=#d7d7d7 guibg=#000000 gui=bold
 
let g:currentmode = {
\ 'n' : 'NORMAL',
\ 'v' : 'VISUAL',
\ 'V' : 'V-LINE',
\ "\<C-V>" : 'V-BLOCK',
\ 'i' : 'INSERT',
\ 'R' : 'REPLACE',
\ 'Rv' : 'V-REPLACE',
\ 'c' : 'COMMAND',
\}


set statusline=
set statusline+=%#Icon#
set statusline+=💅
set statusline+=\ %#NormalC#%{(mode()=='n')?'\ NORMAL\ ':''} 
set statusline+=\ %#InsertC#%{(mode()=='i')?'\ INSERT\ ':''} 
set statusline+=\ %#VisualC#%{(mode()=='v')?'\ VISUAL\ ':''} 
set statusline+=%#Filename#
" set statusline+=\ %f "filename only following option shows full path
set statusline+=\ %F
set statusline+=%#ReadOnly#
set statusline+=\ %r
set statusline+=%m
set statusline+=%=
set statusline+=%#Fileformat#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}\]
set statusline+=%#Position#
set statusline+=\ [L%l/%L\ %p%%\ C%c] 

function! StatuslineMode()
  let l:mode = mode()
  let l:mode_name = get(g:currentmode, l:mode, l:mode)

  if l:mode ==# 'n'
    let l:hl = '%#NormalC#'
  elseif l:mode ==# 'i'
    let l:hl = '%#InsertC#'
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-V>"
    let l:hl = '%#VisualC#'
  elseif l:mode ==# 'R' || l:mode ==# 'Rv'
    let l:hl = '%#ReplaceC#'
  elseif l:mode ==# 'c'
    let l:hl = '%#CommandC#'
  else
    let l:hl = '%#NormalC#'
  endif

  return l:hl . ' ' . l:mode_name . ' '
endfunction

