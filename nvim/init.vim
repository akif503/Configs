source $HOME/.config/nvim/confs/plugins.vim

" Settings
set number
" Mappings
inoremap jj <ESC>
" requirement for nvim-comple
set completeopt=menuone,noselect

let g:onedark_color_overrides = {
\ "black": {"gui": "#1e222a", "cterm": "235", "cterm16": "0" },
\ "green": {"gui": "#7eca9c", "cterm": "235", "cterm16": "0" },
\ "blue": {"gui": "#61afef", "cterm": "235", "cterm16": "0" },
\}

colo onedark

set termguicolors
set encoding=UTF-8
set autochdir

" Completion mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

inoremap jk <ESC>
nnoremap <C-n> :Lexplore<CR>

" Escape Terminal
tnoremap <ESC> <C-\><C-n>
tnoremap <C-[> <C-\><C-n>

" Execute Tex
autocmd BufWritePost *.tex silent! !runLatex %
" autocmd BufWritePost *.tex !pdflatex % > /dev/null

lua << EOF
local lsp = require 'lspconfig'

-- require 'colorizer'.setup()
require 'statusline'

--lsp.texlab.setup{
--    filetypes = { "tex", "plaintex", "bib" }
--}
lsp.pyls.setup{}
lsp.hls.setup{
    -- root_dir = lsp.util.root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", "*") 
}
lsp.clangd.setup{}
lsp.texlab.setup{}
require('nvim-autopairs').setup{
    build = {
        onSave = true
    }
}

require 'completion'
require 'options'
require 'mappings'

-- vim.g.theme = "onedark"
EOF
