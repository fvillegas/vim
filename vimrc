" github.com/garybernhardt/dotfiles
" github.com/mislav/vimfiles
" github.com/carlhuda/janus
" vimcasts.org
" vim.wikia.com
" for more info on any settings
" :help <command> eg
" :help showcmd

call pathogen#infect()          " load pathogen
set nocompatible                " choose no compatibility with legacy vi
set encoding=utf-8              " sensible encoding
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
set number                      " need those line numbers
set ruler                       " show the line/column number of the cursor position
" set shell=sh                    " hack for rvm
"" Whitespace
set nowrap                      " wrap lines, switch with set nowrap
set textwidth=78                "
set linebreak                   " break line for wrapping at end of a word
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set scrolloff=3                 " Minimum number of screen lines to keep above/below the cursor

" indent code inside p tags
autocmd TabEnter,WinEnter,BufWinEnter *.html,*.erb let g:html_indent_tags = g:html_indent_tags.'\|p'

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set wildmenu                    " enhanced command line completion
set wildignore+=*.o,*.obj,.bundle,coverage,.DS_Store,_html,.git,*.rbc,*.class,.svn,vendor/gems/*,vendor/rails/*

"" Colors
" set term=xterm-256color
syntax enable
" set background=dark             " or light
colorscheme desert " can't work with anything else
" highlight LineNr ctermfg=darkgrey
" set cursorline                  " highlight current line

" Window
" set cmdheight=2                 " number of lines for the command line
set laststatus=2                " always have a status line
" set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" set showtabline=2               " always show tab bar
set winwidth=84                 " 

" Mappings
let mapleader=","               " use , as leader instead of backslash

" CTags
" navigate with <c-]> / <c-t>
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
map <C-\> :tnext<CR>

" switch most recent buffers
nnoremap <leader><leader> <c-^> 

" remove whitespace
map <leader>s :%s/\s\+$//<CR>

" clear the search buffer
nnoremap <CR> :nohlsearch<cr>

" Tabs
nmap <leader>[ :tabprevious<cr>
nmap <leader>] :tabNext<cr>
nmap T :tabnew<cr>

" Splits
" quick split and jump into window
map :vs :vsplit<cr><c-l>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" open split scratch buffer
nmap <leader>; :Sscratch<cr>

" edit or view in same dir
map <leader>e :edit %%
map <leader>v :view %%

" Remap shift key failure
command! W :w
command! Wq :wq
command! E :e

" force vim
" map <Left> :echo "damnit!"<cr>
" map <Right> :echo "you suck!"<cr>
" map <Up> :echo "this is why you fail"<cr>
" map <Down> :echo "nooooo!"<cr>

" Plugin mappings
" Fugutive shortcuts
" map :gs :Gstatus<cr>
" map :gb :Gblame<cr>
" map :gd :Gdiff<cr>

"  Ack
map <leader>/ :Ack<space>

" Powerline
" let g:Powerline_symbols = 'fancy'

" Map keys to go to specific files
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>


" Running tests
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!bundle exec cucumber " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

 " When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif
augroup END

" Resize windows quickly
" reset with <c-w>=
nmap <leader>hh :vertical res +20<cr>
nmap <leader>ll :vertical res -20<cr>
" Scroll other window
function! ScrollOtherWindowDown(count)
  normal! 
  normal! 
  normal! 
endfunction
function! ScrollOtherWindowUp(count)
  normal! 
  normal! 
  normal! 
endfunction
nnoremap <c-w>y :call ScrollOtherWindowUp(v:count)<cr>
nnoremap <c-w>e :call ScrollOtherWindowDown(v:count)<cr>

" Give a shortcut key to NERD Tree
map <F2> :NERDTreeToggle<CR>
