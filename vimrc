
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Jan 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" expand tabs to spaces
set expandtab
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" PERSONAL CHANGES

" do not leave backup files in the working directory
" set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
" set directory=~/.vim/.swp//

" my mappings

" easier navigation in the quickfix list
nmap ]q :cn<CR>
nmap [q :cp<CR>
nmap ]Q :clast<CR>
nmap [Q :cfirst<CR>
" easier navigation in the location list
nmap ]l :lnext<CR>
nmap [l :lprev<CR>
nmap ]L :llast<CR>
nmap [L :lfirst<CR>
" easier navigation in the buffer list
nmap ]b :bn<CR>
nmap [b :bp<CR>
nmap ]B :blast<CR>
nmap [B :bfirst<CR>
" easier navigation in the tags list
nmap ]t :tn<CR>
nmap [t :tp<CR>
nmap ]T :tlast<CR>
nmap [T :tfirst<CR>

" jumping between C functions with end-of-line { convention
" nmap [[ 99]}[]%
" nmap ]] 99]}][%
" recommended by :h [[
nmap [[ ?{<CR>w99[{
nmap ][ /}<CR>b99]}
nmap ]] j0[[%/{<CR>
nmap [] k$][%?}<CR>

" for project hpc_rotations: some macros
let @s = '^iSAFE_CALL(AOD, err)'

" function for performing grep on TODO
" (not strictly practical but kept here as a reminder for the options)
function Todo()
    grep -riIw TODO *
    " -r for recursive
    " -i for case-insensitive
    " -I for ignoring binaries
    " -w for whole words
endfunction

" show line number
set number

" for compatibility with tmux, always set background mode
" (see https://unix.stackexchange.com/questions/348771/why-do-vim-colors-look-different-inside-and-outside-of-tmux)
set background=dark

" for better spell check, limit the size of the correction screen
set spellsuggest+=20

" plugins

packadd! vim-airline
let g:airline#extensions#tabline#enabled = 1 " buffer bar
let g:airline_symbols_ascii = 1 " get rif of weird symbols

colorscheme gruvbox
"add red highlight to TODO
highlight Todo ctermbg=1 guibg=#ff0000

packadd! vim-gitgutter
set updatetime=100 " recommended for gitgutter

packadd! vim-fugitive
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''} " set branch in status line

packadd! vimtex
let g:vimtex_view_method = 'zathura'
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif
let g:vimtex_grammar_textidote = {
            \ 'jar': '/usr/local/bin/textidote.jar',
            \ 'args': '--check en',
            \}
let g:tex_flavor = 'latex'
let g:vimtex_grammar_vlty = {'lt_directory': '/home/guyon/.languagetool/LanguageTool-6.4-SNAPSHOT/', 'shell_options':  ' --packages "*"'}
set spelllang=en_us
" map <F9> :w <bar> compiler vlty <bar> make <bar> :cw <cr><esc>
map <F9> :w <bar> compiler vlty <bar> make <bar> :cw <cr><esc>

" map <F9> :w <bar> compiler vlty <bar> make <bar> :cw <cr><esc>
" let g:tex_flavor = 'latex'
" set spelllang=en_US
" let g:vimtex_grammar_vlty = {}
" let g:vimtex_grammar_vlty.lt_directory = '/usr/local/bin/LanguageTool-6.3'
" " let g:vimtex_grammar_vlty.lt_command = 'languagetool'
" let g:vimtex_grammar_vlty.server = 'my'
" let g:vimtex_grammar_vlty.show_suggestions = 1
" let g:vimtex_grammar_vlty.shell_options =
"             \   ' --multi-language'
"             \ . ' --packages "*"'
"             \ . ' --define ~/vlty/defs.tex'
"             \ . ' --replace ~/vlty/repls.txt'
"             \ . ' --equation-punctuation display'
"             \ . ' --single-letters i.\,A.\|z.\,B.\|\|"'

packadd! fzf
packadd! fzf.vim
nmap <Leader>f :Rg<CR>
nmap <Leader>c :Commits<CR>
nmap  :Files<CR>
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" CUSTOM: search from ~/
nmap <Leader>~ :FZF ~


packadd! ale
" let g:ale_linter_aliases={'tex':['tex','text']}
" let g:ale_linters={'tex': ['languagetool']}
" let g:languagetool_jar = '/home/guyon/.languagetool/LanguageTool-6.4-SNAPSHOT/languagetool-commandline.jar'
" let g:ale_languagetool_executable = '/home/guyon/.languagetool/LanguageTool-6.4-SNAPSHOT/languagetool-commandline.jar'

" Show cursorline
set cursorline
" hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
" highlight CursorLine guibg=#303000 ctermbg=234
" highlight only the column number (but expression just below messed up style
" of borders)
" highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
" highlight CursorLine ctermbg=NONE
