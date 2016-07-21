set encoding=utf-8

" *** abbreviate functions
function! CommandCabbr(abbreviation, expansion)
    execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
" Use it on itself to define a simpler abbreviation for itself.
CommandCabbr ccab CommandCabbr

" *** NERDTree
CommandCabbr nt NERDTree
CommandCabbr ntf NERDTreeFind

set nocompatible

" set leader key to be space
let mapleader = "\<Space>"

" Automatically install vim-plug if it's not set up.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" vim-plug package manager setup
call plug#begin('~/.vim/plugged')

" plugins
Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
let g:fugitive_github_domains = ['github.com', 'git.musta.ch']

" ctrlp fuzzy matcher
" ----------------------------------------------------------------------
Plug 'ctrlpvim/ctrlp.vim'
" use ag to index
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

" faster python-based matcher for ctrlp
Plug 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Only refreshes the results every 100ms so if you
" you type fast searches don't pile up
let g:ctrlp_lazy_update = 100 

" Trying out fzf
" ----------------------------------------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Prefix all fzf-related commands with Fzf
let g:fzf_command_prefix = 'Fzf'

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" - window (nvim only)
let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Command-local options

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R --languages=-javascript'

" allow us to call :FzfAg with options
function! s:ag_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#ag(query, ag_opts, a:bang ? {} : {'down': '40%'})
endfunction

autocmd VimEnter * command! -nargs=* -bang Ag call s:ag_with_opts(<q-args>, <bang>0)

" ag word under cursor
nnoremap <silent> <Leader>ag :FzfAg <C-R><C-W><CR>

" fzf leader bindings
nnoremap <silent> <Leader>f :FzfFiles<CR>
nnoremap <silent> <Leader>b :FzfBuffers<CR>
nnoremap <silent> <Leader>l :FzfLines<CR>

" ----------------------------------------------------------------------

Plug 'pangloss/vim-javascript' " required for vim-jsx plugin to work
Plug 'mxw/vim-jsx' " syntax highlighting for JSX files

Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

set laststatus=2 " display airline bar even when there is only one window open

Plug 'scrooloose/syntastic'
" Airbnb recommended settings
" Always add any detected errors into the location list
let g:syntastic_always_populate_loc_list = 1

" Don't auto-open it when errors/warnings are detected, but auto-close when no
" more errors/warnings are detected.
let g:syntastic_auto_loc_list = 2

" Highlight syntax errors where possible
let g:syntastic_enable_highlighting = 1

" Show this many errors/warnings at a time in the location list
let g:syntastic_loc_list_height = 5

" Don't run checkers when saving and quitting--only on saving
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol         = '×' " There are better characters, but Hackpad won't show them
let g:syntastic_warning_symbol       = '⚠'
let g:syntastic_style_error_symbol   = '⚠'
let g:syntastic_style_warning_symbol = '⚠'

let g:syntastic_javascript_checkers    = ['eslint']
let s:eslint_path                      = system('PATH=$(npm bin):$PATH && which eslint')
let g:syntastic_javascript_eslint_exec = substitute(s:eslint_path, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
let g:syntastic_json_checkers          = ['jsonlint']
let g:syntastic_ruby_checkers          = ['rubocop']
let g:syntastic_scss_checkers          = ['scss_lint']
let g:syntastic_vim_checkers           = ['vint']
let g:syntastic_enable_signs = 1

" syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open = 1
" custom settings
let g:syntastic_mode_map = {
  \ "mode": "active",
  \ "passive_filetypes": ["eruby", "ruby"]
  \}
command SC SyntasticCheck
command SI SyntasticInfo
command STM SyntasticToggleMode
command LC Errors
" have :q also close syntastic if it's open
cabbrev q lcl\|q
cabbrev wq w\|silent!lcl\|q

" ruby checker
let g:syntastic_ruby_exec = '/Users/owen_lin/.rvm/rubies/ruby-1.9.3-p551/bin/ruby'

" Fzf still somehow overrides this: https://github.com/junegunn/fzf.vim/issues/83
Plug 'rking/ag.vim' | Plug 'Chun-Yang/vim-action-ag'
" This plugin is GARBAGE
" Need to:
" 1) Don't open the first result by default
" 2) On e or <CR>, open in the last focused window
" 3) On h or v, open to the right or bottom of last focused window
" Related issue, but no real resolution:
" https://github.com/rking/ag.vim/issues/92

" Easily define new text objects
Plug 'kana/vim-textobj-user'

" Ruby text objects (method text objects already work, but this adds support
" for Ruby blocks)
Plug 'nelstrom/vim-textobj-rubyblock' " requires kana/vim-textobj-user

" All plugins must be added before the following line
call plug#end()            " required

" Non-plugin related setup 
color desert
filetype plugin indent on
set nu
set backspace=indent,eol,start
syntax enable
set showmode
set showcmd
set wildmenu
set ruler<
runtime ftplugin/man.vim
set expandtab
set nowrap
set hlsearch
set showmatch
set ignorecase
set smartcase
" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
" Indent options
set tabstop=2
set shiftwidth=2
set expandtab
set modifiable " to create files/directories in NERDTree
set splitbelow
set splitright

" *** strip trailing whitespace for certain files
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python,yaml,yml,js,css,scss,erb autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" persistent undo
if !isdirectory($HOME."/.vim")
  call mkdir($HOME."/.vim")
endif
if !isdirectory($HOME."/.vim/undo")
  call mkdir($HOME."/.vim/undo")
endif
set undodir=$HOME/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

" disable Ctrl-w o
map <C-w>o <Nop>

" allow % to jump around if/elsif/else/end and XML tags
runtime macros/matchit.vim

" Search for visually selected text, forwards with '*' or backwards with '#'.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" show lines above and below search results
set scrolloff=10

" Easy expansion of the active file directory in Command mode
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Incremental search
set incsearch

" Makes & repeat the last substitution with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Set up omni complete, accessed with <C-x><C-o> in insert mode
set omnifunc=syntaxcomplete#Complete

" Trying out jj to exit insert mode
inoremap jj <Esc>

" ------ Leader mappings ------
" Simplify system clipboard interaction
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

nnoremap <Leader>d "+d
vnoremap <Leader>d "+d

nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P
