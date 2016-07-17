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
set clipboard+=unnamedplus,unnamed
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

" Neocomplete {{{
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
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
" solarized
let g:solarized_degrade     = 0
let g:solarized_bold        = 1
let g:solarized_underline   = 1
let g:solarized_italic      = 1
let g:solarized_termtrans   = 0
let g:solarized_contrast    = 'normal'
let g:solarized_visibility  = 'normal'
let g:solarized_termcolors  = 256

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

if has('nvim')
  let g:loaded_python_provider = 1
  let g:python3_host_prog = expand('$HOME') . '/.pyenv/shims/python3'
  let s:hooks = neobundle#get_hooks("deoplete.nvim")
  function! s:hooks.on_source(bundle)
    let g:deoplete#enable_at_startup = 1
  endfunction
else
  " Neocomplete {{{
  let s:hooks = neobundle#get_hooks("neocomplete.vim")
  function! s:hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#max_list          = 20
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#enable_smart_case = 1
    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplete#force_omni_input_patterns['default'] = '\h\w*'
    let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : '',
          \ 'scala' : $HOME . '/.vim/dict/scala.dict',
          \ }
  endfunction
endif
"}}}

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown,eruby setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" neosnippet {{{
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets, ~/.vim/snippets'
"}}}

" previm
let g:previm_open_cmd = 'open -a Safari'

let g:indent_guides_enable_on_vim_startup = 1

" lightline.vim

let g:lightline = {
      \ 'component': {
      \   'readonly': '%{&readonly?"\u2b64":""}',
      \ },
      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
      \ }


" neocompleteと併用する場合の設定
if !exists("g:neocomplete#force_omni_input_patterns")
  let g:neocomplete#force_omni_input_patterns = {}
else
  let g:neocomplete#force_omni_input_patterns.d = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#rsense#home_directory = '/usr/local/bin/rsense'
let g:rsenseUseOmniFunc = 1
let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'

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
  let g:syntastic_cpp_compiler_options = '--std=c++11 --stdlib=libc++'
  let g:quickrun_config['cpp/clang++11'] = {
      \ 'cmdopt': '--std=c++11 --stdlib=libc++',
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
"}}}

augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END
