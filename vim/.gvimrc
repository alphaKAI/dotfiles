if has('mac')
  set transparency=10
else
  "Linux
endif

set background=dark
colorscheme badwolf
highlight CursorLine ctermbg=lightgray
let g:vimshell_editor_command = '/usr/local/Cellar/macvim/7.4-77/bin/gvim'

