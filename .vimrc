" set runtimepath^=~/.vim/plugins/vim-xkbswitch

set number
" turns <TAB>s into spaces
" set expandtab

set backspace=indent,eol,start	" more powerful backspacing

set cursorline
set showcmd             " show command in bottom bar
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

set ttymouse=xterm2
set mouse=a

set ttimeoutlen=0

nmap yy yy:silent .w !xclip -i -sel clipboard<cr>
vmap y y:silent '<,'> w !xclip -i -sel clipboard<cr>
colo desert
syntax on
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <A-Left> :-tabmove<CR>
nnoremap <A-Right> :+tabmove<CR>

noremap <C-N><C-N> :set invnumber<CR>
noremap <C-N>1 :set relativenumber<CR>
noremap <C-N>0 :set norelativenumber<CR>


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

