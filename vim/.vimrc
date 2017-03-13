" --------------- Vundle -----------------

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'chriskempson/base16-vim'
" Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'dkprice/vim-easygrep'
Plugin 'jreybert/vimagit'
Plugin 'raimondi/delimitmate'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'kabbamine/vcoolor.vim'
Plugin 'mileszs/ack.vim'
Plugin 'morhetz/gruvbox'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Shougo/neocomplete'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'stanangeloff/php.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'gabesoft/vim-ags'
Plugin 'valloric/matchtagalways'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'xuyuanp/nerdtree-git-plugin'

call vundle#end()
filetype plugin indent on

" ------------ Configuraciones ------------

" Línea en blanco
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Tema
set t_Co=256
set background=dark
let base16colorspace=256
colorscheme gruvbox

syntax on
set backspace=2
set history=1000
set showcmd
set wildmenu
set wildmode=full
set incsearch
set autoread
set lazyredraw
set splitright
set nu
set relativenumber
filetype plugin on

let keyword_patterns = {}
let keyword_patterns.html = '@\?\h\w*'
  let keyword_patterns.javascript = '@\?\h\w*'
  let keyword_patterns.css = '@\?\h\w*'
call neocomplete#custom#source('neosnippet',
\ 'keyword_patterns', keyword_patterns)

" Deshabilitar generación automática de backups
set nobackup
set nowritebackup
set noswapfile

" Habilitar mouse :P
if has('mouse')
  set mouse=a
endif

" Regresar a la misma línea si un archivo es abierto de nuevo
augroup line_return
  au!
  au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

let g:ackprg = 'ag --nogroup --nocolor --column'

" Tabulación
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Cursor de Tmux
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=1\x7"
endif

" Linea en blanco al final del archivo
function! <SID>StripTrailingWhitespaces()
  " Guarda la última búsqueda y la posición del cursor
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

" Posición del cursor
" set cursorcolumn
" set cursorline

" Indentación
set smartindent
set smarttab

" CtrlP show hidden files
let g:ctrlp_show_hidden = 1

" Bug en neosnippet
" inoremap <expr><CR> neosnippet#expandable() ? neosnippet#mappings#expand_or_jump_impl() : pumvisible() ? neocomplete#close_popup() : "\<CR>"
" Neosnippet
imap <C-k>  <Plug>(neosnippet_expand_or_jump)
smap <C-k>  <Plug>(neosnippet_expand_or_jump)
xmap <C-k>  <Plug>(neosnippet_expand_target)

" Sintaxis en prawn
au BufNewFile,BufRead *.prawn set filetype=ruby
au BufNewFile,BufRead *.axlsx set filetype=ruby
au BufRead,BufNewFile *.hamlc set filetype=haml

" Mostrar archivos ocultos en NERDTree
let NERDTreeShowHidden=1

" Símbolos para airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Airline
set laststatus=2
let g:airline_theme = 'base16'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \}

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><C-g>    necomplete#undo_completion()
inoremap <expr><C-l>    necomplete#complete_common_string()

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#CompleteTags

if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Comandos
map <C-p> :FZF<ENTER>
map <C-l> :tabn<ENTER>
map <C-h> :tabp<ENTER>

