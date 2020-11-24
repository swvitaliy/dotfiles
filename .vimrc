" set runtimepath^=~/.vim/plugins/vim-xkbswitch

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-t> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

Plug 'wincent/terminus'
" Plug 'vim-syntastic/syntastic'

Plug 'dense-analysis/ale'

call plug#end()

let g:bufferline_echo = 0
let g:molokai_original = 1
let g:airline_theme = 'term'

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_match_window = 'min:4,max:33'

" write in buffer when close buffer
set autowriteall
nnoremap <C-b> :buffers<CR>:buffer<Space>

" show diff of line of code
map <C-c> :SignifyHunkDiff<CR>

" undo changes of line of code
map <C-x> :SignifyHunkUndo<CR>

" ALE
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '·'


" let g:ale_linters = {'javascript':['eslint', 'fecs', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']}
" let g:ale_linters = {'javascript':['flow-language-server']}
let g:ale_linters_ignore = {'javascript':['tsserver']}

" let g:ale_javascript_flow_executable = 'flow'
let g:ale_javascript_flow_use_respect_pragma = 1

let g:ale_fixers = {'javascript': ['prettier', 'eslint']}

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1

" End of ALE

helptags ~/.vim/doc
" source ~/.vim/plugin/matchit.vim
" /usr/include/c++/7
let &path.="/usr/include/c++/7"

" disable selection when press Enter twice or Space
nnoremap <cr> :noh<CR><CR>:<backspace>
map <Space> :noh<CR>

set number

" use spaces instead tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


" set backspace=indent,eol,start	" more powerful backspacing

set cursorline
set showcmd             " show command in bottom bar
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=syntax

set ttymouse=xterm2
set mouse=a

set ttimeoutlen=0

set undofile " Maintain undo history between sessions
set undodir=~/.vim_undo

nmap yy yy:silent .w !xclip -i -sel clipboard<cr>
vmap y y:silent '<,'> w !xclip -i -sel clipboard<cr>

" colorscheme
colo molokai

syntax on
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <A-Left> :-tabmove<CR>
nnoremap <A-Right> :+tabmove<CR>

noremap <C-N><C-N> :set invnumber<CR>
noremap <C-N>1 :set relativenumber<CR>
noremap <C-N>0 :set norelativenumber<CR>

nnoremap I i<CR>


autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
autocmd InsertLeave * highlight CursorLine guibg=#004000 guifg=fg

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv=1
nnoremap <g-n> :Ntree<CR>

map Y y$

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
noremap <F3> :set list!<CR>

set autoindent

set colorcolumn=110
highlight ColorColumn ctermbg=lightgray

" Save file with sudo
command! -nargs=0  WriteWithSudo :w !sudo tee % >/dev/null

" Use :ww instead of :WriteWithSudo
cnoreabbrev ww WriteWithSudo

" Insert snippets
function! InsertTemplate(name)
	:execute "read ~/.vim_templates/" . a:name
endfunction

command! -nargs=1 InsertTemplate :call InsertTemplate(<f-args>)
cnoreabbrev it InsertTemplate

" Git commit on vim write
function! GitCommit()
	:execute '!if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then git add % && git commit -m "change %"; fi'
endfunction

command! -nargs=0 GitCommit :call GitCommit()
cnoreabbrev gci GitCommit

function! GitCommitPush()
	:execute '!if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then git add % && git commit -m "change %"; git push; fi'
endfunction

command! -nargs=0 GitCommitPush :call GitCommitPush()
cnoreabbrev gcp GitCommitPush

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" if $DISPLAY == ""
" 	set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
" 	let g:XkbSwitchEnabled = 0
" else
" 	let g:XkbSwitchEnabled = 1
" 	if filereadable('/usr/local/lib/libg3kbswitch.so')
" 		let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so'
" 	endif
"
" 	let g:XkbSwitchAssistNKeymap = 1    " for commands r and f
" 	let g:XkbSwitchAssistSKeymap = 1    " for search lines
" 	let g:XkbSwitchIMappings = ['ru']
" endif

set pastetoggle=<F2>

autocmd BufWritePre * :%s/\s\+$//e

