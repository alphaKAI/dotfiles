scriptencoding utf-8

" Initialize {{{
if has('vim_starting')
  filetype plugin off
  filetype indent off
  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch "Shougo/neobundle.vim"
call neobundle#end()

if filereadable(expand('~/.vim_neobundle'))
  " Define Plugins => ~/.vim_neobundle
  call neobundle#begin(expand('~/.vim/bundle/'))
    source ~/.vim_neobundle
  call neobundle#end()
endif

" Activate mouse
if has('mouse')
  set mouse=a
endif

" Check New Bundle
NeoBundleCheck

" Editor Settings {{{
" Enable backspace
set backspace=indent,eol,start

" Encoding
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" ClipBoard
" for OSX: set clipboard+=unnamedplus,unnamed
set clipboard=unnamedplus
set nrformats-=octal
set ambiwidth=double
set wildmenu

" Search
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

" goto last time edited line
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" lines
set number

" Syntax
set showmatch matchtime=1

" TabKey
set ts=2
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

" Indent
set autoindent
set cindent
set breakindent

" Paste mode toggle
set pastetoggle=<C-E>

" No Auto Comment
filetype plugin indent on
autocmd FileType * setlocal formatoptions-=ro

" View
set cmdheight=2
set laststatus=2
set title
set showcmd
set display=lastline

" Filetypes
autocmd BufRead,BufNewFile *.md set filetype=markdown
au BufNewFile,BufRead *.scala setf scala


"nobeep
set visualbell t_vb=
set noerrorbells

set foldmethod=marker

" Vim Tab
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
"}}}

" key mapping {{{
" Unset Searched high light : Ctrl + L
nnoremap <C-h><C-l> :nohl<CR>
"<C-L>
nnoremap <C-L> :VimFiler -split -simple -winwidth=35 -no-quit<CR>

" Search world from selected area : *
vnoremap * "zy:let @/ = @z<CR>n

" redo : Ctrl + r
nnoremap <C-r> :redo<CR>
" undo : Ctrl + u
nnoremap <C-u> :undo<CR>

" NERDTree toggle : Ctrl + N + T
nnoremap <C-n><C-t> :NERDTree<CR>

" メモ系
map <Leader>mn  :MemoNew<CR>
map <Leader>ml  :MemoList<CR>
map <Leader>mg  :MemoGrep<CR>

"auto cd
"au BufEnter *.* execute ":lcd " . expand("%:p:h")

nnoremap <C-t><C-u> :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLocation = 'topleft'
let g:undotree_SplitWidth = 35
let g:undotree_diffAutoOpen = 1
let g:undotree_diffpanelHeight = 25
let g:undotree_RelativeTimestamp = 1
let g:undotree_TreeNodeShape = '*'
let g:undotree_HighlightChangedText = 1
let g:undotree_HighlightSyntax = "UnderLined"

"Open TagList Toggle : Ctrl + k
nnoremap <C-t><C-l> :Tlist<CR>

" insert empty line in normal mode
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j

" Neosnippet {{{
" Plugin key-mappings.
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"
"}}}

"Scheme
aug Scheme
  au!
  au Filetype scheme setl cindent& lispwords=define 
aug END
"}}}

" Color Setting {{{
syntax enable
set background=dark

colorscheme gruvbox
"colorscheme badwolf
"colorscheme twilight

" pervious
"highlight Normal ctermbg=none

set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black
"lightgray

" statusline
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" status colorscheme
augroup InsertHook
  autocmd!
  autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
  autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

" imporve color of vimdiff
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

"}}}

" Plugin settings {{{
compiler ruby
let ruby_space_errors=1

" Emmet
let g:user_emmet_settings = {
      \   'lang' : 'ja'
      \ }

" Jump to the brackets to the corresponding : %
" source $VIMRUNTIME/macros/matchit.vim

" deoplete
let g:deoplete#enable_at_startup = 1

set completeopt=menuone

" neosnippet {{{
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snippets'
"}}}

" previm
let g:previm_open_cmd = 'xdg-open '

let g:indent_guides_enable_on_vim_startup = 1

" lightline.vim

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"[ReadOnly] \ue0a2":""}'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

" <F1>でドキュメントを開く
autocmd FileType d nnoremap <buffer> <F1> :DUddoc<CR>
" \dで定義元にジャンプ
autocmd FileType d nnoremap <buffer> \d :DUjump<CR>

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

let g:openbrowser_open_filepath_in_vim = 0
let g:openbrowser_open_rules = {'open' : 'open -a Safari {shellescape(uri)}&'}
nnoremap[ :silent OpenBrowser %
command! OpenBrowserCurrent execute "OpenBrowser" expand("%:p") 

let g:quickrun_config = {}
if executable("clang++")
  let g:syntastic_cpp_compiler = 'clang++'
  let g:syntastic_cpp_compiler_options = '--std=c++11'
  let g:quickrun_config['cpp/clang++11'] = {
      \ 'cmdopt': '--std=c++11',
      \ 'type': 'cpp/clang++'
    \ }
  let g:quickrun_config['cpp'] = {'type': 'cpp/clang++11'}
endif
let g:syntastic_check_on_wq = 0


"vim-rooter
if ! empty(neobundle#get("vim-rooter"))
  " Change only current window's directory
  let g:rooter_use_lcd = 1
  " files/directories for the root directory
  let g:rooter_patterns = ['tags', '.git', '.git/', '_darcs/', '.hg/', '.bzr/', 'Makefile', 'GNUMakefile', 'GNUmakefile', '.svn/']
  " Automatically change the directory
  "autocmd! BufEnter *.c,*.cc,*.cxx,*.cpp,*.h,*.hh,*.java,*.py,*.sh,*.rb,*.html,*.css,*.js :Rooter
endif

" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')

execute "set rtp+=" . g:opamshare . "/merlin/vim"
let g:syntastic_ocaml_checkers = ['merlin']


execute 'set rtp^=' . g:opamshare . '/ocp-indent/vim'
function! s:ocaml_format()
    let now_line = line('.')
    exec ':%! ocp-indent'
    exec ':' . now_line
endfunction

augroup ocaml_format
    autocmd!
    autocmd BufWrite,FileWritePre,FileAppendPre *.mli\= call s:ocaml_format()
augroup END

let g:LanguageClient_serverCommands = {
    \ 'c': ['clangd', '-compile-commands-dir=' . getcwd() . '/build'],
    \ 'cpp': ['clangd', '-compile-commands-dir=' . getcwd() . '/build'],
    \ 'd': ['/home/alphakai/.local/share/code-d/bin/serve-d'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
" \ 'd': ['~/.dub/packages/.bin/dls-latest/dls'],
let g:LanguageClient_rootMarkers = {
    \ 'd': ['dub.json', 'dub.sdl'],
    \ }


"}}}

