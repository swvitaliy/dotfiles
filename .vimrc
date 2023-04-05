source ~/.vimrc0

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

map <C-t> :NERDTreeToggle<CR>

call plug#begin('~/.vim/plugged')
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'

  Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mihaifm/bufstop'
Plug 'neoclide/coc-eslint'
" Plug 'jiangmiao/auto-pairs'
Plug 'puremourning/vimspector'
Plug 'wookayin/fzf-ripgrep.vim'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
" Plug 'maxmellow/vim-jsx-pretty'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'branch': 'release/0.x'
  \ }


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
Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-surround'
" Plug 'Exafunction/codeium.vim'
Plug 'sirver/UltiSnips'

call plug#end()


"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme onedark

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim_templates']
let g:UltiSnipsExpandTrigger="<tab>"

" let g:molokai_original = 1
" let g:airline_theme = 'base16_adwaita'
" let g:airline_theme = 'ravenpower'
" let g:airline_theme = 'dark'

let g:airline#extensions#tabline#buffer_nr_show = 1

" Prettier configs
let g:prettier#quickfix_enabled = 1
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeWinSize=43

let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'

" let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_match_window = 'min:4,max:33'

" write in buffer when close buffer
set autowriteall
nnoremap <C-b> :Buffers<CR>

" show diff of line of code
map <C-c> :SignifyHunkDiff<CR>

" undo changes of line of code
map <C-x> :SignifyHunkUndo<CR>

" ALE

" let g:ale_linters = {}
" let g:ale_linters_ignore = {}
"
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '·'
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
"
"
" " let g:ale_linters = {'javascript':['eslint', 'fecs', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']}
" " let g:ale_linters = {'javascript':['flow-language-server']}
" let g:ale_linters_ignore['javascript'] = ['tsserver']
"
" " let g:ale_javascript_flow_executable = 'flow'
" let g:ale_javascript_flow_use_respect_pragma = 1
"
" let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
"
" " Set this variable to 1 to fix files when you save them.
" let g:ale_fix_on_save = 1
"
" let g:ale_completion_enabled = 1
"
" map <C-g> :ALEGoToDefinition<CR>

" End of ALE

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
  set completeopt=longest,menuone,popuphidden,noinsert,noselect
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
" let g:ale_linters['cs'] = ['OmniSharp']

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

"" helptags ~/.vim/doc
" source ~/.vim/plugin/matchit.vim
" /usr/include/c++/7
"" let &path.="/usr/include/c++/7"

" enable/disable enhanced tabline. (c) >
let g:airline#extensions#tabline#enabled = 1

" enable/disable displaying open splits per tab (only when tabs are opened) >
let g:airline#extensions#tabline#show_splits = 1

"  enable/disable displaying buffers with a single tab. (c) >
let g:airline#extensions#tabline#show_buffers = 1

" Keymap Coc
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

autocmd BufWritePre *.cpp :Format

" Nerdtree navigation
nnoremap <leader>nn :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Buffers navigation
map <leader>b :Bufstop<CR>
let g:BufstopAutoSpeedToggle = 1

" Fzf maps
map <Leader>ff :Files<CR>
map <Leader>fb :BLines<CR>
map <Leader>fa :Rg<CR>
let $FZF_DEFAULT_COMMAND = 'fd --type f'

nmap yy yy:silent .w !xclip -i -sel clipboard<cr>
vmap y y:silent '<,'> w !xclip -i -sel clipboard<cr>

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv=1
nnoremap <g-n> :Ntree<CR>


set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
noremap <F3> :set list!<CR>
"
" Save file with sudo
command! -nargs=0  WriteWithSudo :w !sudo tee % >/dev/null

" Use :ww instead of :WriteWithSudo
cnoreabbrev ww WriteWithSudo

" Insert snippets
function! InsertTemplate(name)
	:execute "read ~/.vim_templates/" . a:name
  norm kdd
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

scriptencoding utf-8

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
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

iabbrev #i #include
iabbrev #d #define

"easymotion configuration

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"end of easymotion configuration
"
"
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#afff5f' ctermbg=237 guibg=#3E4452 gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' ctermbg=237 guibg=#3E4452 gui=underline ctermfg=81 cterm=underline





















