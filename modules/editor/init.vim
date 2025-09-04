" Enable syntax and filetype detection
syntax enable
filetype plugin indent on

" Basic editor settings
set encoding=UTF-8
set number
set relativenumber
set hidden
set noerrorbells
set laststatus=2
set noshowmode

" Indentation and formatting
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set nowrap

" Search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" File handling
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Visual settings
set colorcolumn=80
set termguicolors
set background=dark

" Remove auto-commenting on new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Plugin configurations
" CoC.nvim settings
set updatetime=300
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Go settings
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

" Key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :nohlsearch<CR>

" NERDTree toggle
map <C-n> :NERDTreeToggle<CR>
