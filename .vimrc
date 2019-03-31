set number
" turns <TAB>s into spaces
" set expandtab

set cursorline
set showcmd             " show command in bottom bar
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max


nmap yy yy:silent .w !xclip -i -sel clipboard<cr>
vmap y y:silent '<,'> w !xclip -i -sel clipboard<cr>
colo desert
syntax on
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <A-Left> :-tabmove<CR>
nnoremap <A-Right> :+tabmove<CR>

autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
autocmd InsertLeave * highlight CursorLine guibg=#004000 guifg=fg

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv=1
nnoremap <g-n> :Ntree<CR>

set autoindent
