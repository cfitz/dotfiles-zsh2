" vim-plug configuration (https://github.com/junegunn/vim-plug)
" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Essential plugins
Plug 'tpope/vim-sensible'              " Modern vim defaults
Plug 'tpope/vim-fugitive'              " Git integration
Plug 'tpope/vim-surround'              " Delete/change/add surroundings
Plug 'tpope/vim-commentary'            " Comment out code
Plug 'tpope/vim-unimpaired'            " Bracket mappings
Plug 'tpope/vim-repeat'                " Enhance dot command
Plug 'tpope/vim-vinegar'               " Netrw enhancements

" File navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                " Fuzzy finder

" Syntax & language support
Plug 'sheerun/vim-polyglot'            " Language pack
Plug 'vim-ruby/vim-ruby'               " Ruby support
Plug 'pangloss/vim-javascript'         " JavaScript support
Plug 'hail2u/vim-css3-syntax'          " CSS3 syntax
Plug 'othree/html5.vim'                " HTML5 support
Plug 'tpope/vim-markdown'              " Markdown support

" Completion & intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Intellisense engine

" UI improvements
Plug 'vim-airline/vim-airline'         " Status line
Plug 'vim-airline/vim-airline-themes'  " Theme support
Plug 'chriskempson/base16-vim'         " Base16 color schemes

" Text objects & operators
Plug 'kana/vim-textobj-user'           " User-defined text objects
Plug 'kana/vim-textobj-indent'         " Indent text objects

" Formatting & linting
Plug 'sbdchd/neoformat'                " Code formatting
Plug 'dense-analysis/ale'              " Linting

" Git visualization
Plug 'airblade/vim-gitgutter'          " Show git changes in gutter

" Productivity
Plug 'godlygeek/tabular'               " Text alignment
Plug 'mattn/emmet-vim'                 " Emmet abbreviation expansion

call plug#end()

filetype plugin indent on
