set spell
set spl=en_us,ru_ru

autocmd FileType xml setlocal nospell
autocmd FileType sh setlocal nospell
autocmd FileType vim setlocal nospell
autocmd FileType dosini setlocal nospell
autocmd FileType omnisharplog setlocal nospell



set ar
set awa

let s:autoread_timer = -1

fun! s:checktime(timer_id)
    for buf in filter(map(getbufinfo(), {_, v -> v.bufnr}), {_, v -> buflisted(v)})
        exe 'checktime' buf
    endfor
    call timer_start(3000, function('s:checktime'))
endf

command! -bang Autoread
            \  if <bang>0
            \|   call timer_stop(s:autoread_timer)
            \| else
            \|   let s:autoread_timer = timer_start(1000,
            \        function('s:checktime'), {'repeat': -1})
            \| endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

set pastetoggle=<F2>

map <C-t> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

" Enhanced terminal integration for Vim
" Cursor shape change in insert and replace mode
" automatically pick up changes made by other processes
" I disabled this plugin because it sometimes can't paste text in paste mode
" and it disable to do it manually
" Plug 'wincent/terminus'

" Plug 'vim-syntastic/syntastic'
Plug 'dense-analysis/ale'

" Need to install 'lehre' nodejs module in system modules
"   nvm use system # if use nvm
"   [sudo] npm install -g lehre
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}

let g:jsdoc_lehre_path = '/usr/local/bin/lehre'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'OmniSharp/omnisharp-vim'

Plug 'editorconfig/editorconfig-vim'

"
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'

call plug#end()

let g:molokai_original = 1
" let g:airline_theme = 'base16_adwaita'
" let g:airline_theme = 'ravenpower'
" let g:airline_theme = 'dark'

let g:airline#extensions#tabline#buffer_nr_show = 1


let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeWinSize=43

let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'

map <C-p> :bp<CR>
map <C-n> :bn<CR>

" go to last edited file
map <C-e> :e#<CR>

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

let g:ale_linters = {}
let g:ale_linters_ignore = {}

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '·'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow


" let g:ale_linters = {'javascript':['eslint', 'fecs', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']}
" let g:ale_linters = {'javascript':['flow-language-server']}
let g:ale_linters_ignore['javascript'] = ['tsserver']

" let g:ale_javascript_flow_executable = 'flow'
let g:ale_javascript_flow_use_respect_pragma = 1

let g:ale_fixers = {'javascript': ['prettier', 'eslint']}

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1

map <C-g> :ALEGoToDefinition<CR>

" End of ALE

nnoremap <Tab>   <c-W>w
nnoremap <S-Tab> <c-W>W

cnoreabbrev <expr> os (getcmdtype() == ':' && getcmdline() =~ '^os') ? 'OpenSession' : 'os'
cnoreabbrev <expr> cs (getcmdtype() == ':' && getcmdline() =~ '^cs') ? 'CloseSession' : 'cs'
cnoreabbrev <expr> ss (getcmdtype() == ':' && getcmdline() =~ '^ss') ? 'SaveSession' : 'ss'

" OmniSharp-vim
" https://github.com/OmniSharp/omnisharp-vim#configuration

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet:
" https://github.com/neovim/neovim/issues/10996
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters['cs'] = ['OmniSharp']

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

" Enable snippet completion, using the ultisnips plugin
" let g:OmniSharp_want_snippet=1

let g:OmniSharp_diagnostic_showid = 1

" End of OmniSharp-vim

helptags ~/.vim/doc
" source ~/.vim/plugin/matchit.vim
" /usr/include/c++/7
let &path.="/usr/include/c++/7"

" disable selection when press Enter twice or Space
nnoremap <cr> :noh<CR><CR>:<backspace>
map <Space> :noh<CR>

set number

" use spaces instead tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab


" set backspace=indent,eol,start	" more powerful backspacing

" set cursorline
set showcmd             " show command in bottom bar
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent

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

noremap <C-M>~ :set invnumber<CR>
noremap <C-M>1 :set relativenumber<CR>
noremap <C-M>0 :set norelativenumber<CR>

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

" set colorcolumn=110
" highlight ColorColumn ctermbg=lightgray

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


autocmd BufWritePre * :%s/\s\+$//e

