syntax on
set number
set shiftwidth=4

" non vi compatible mode
set nocp 
" enable plugins
filetype plugin indent on 

" auto close options when exiting insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
set completeopt=menu,menuone

" enable pathogen
execute pathogen#infect()

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
" show function parameters
let OmniCpp_ShowPrototypeInAbbr = 1 
" autocomplete after .
let OmniCpp_MayCompleteDot = 1 
" autocomplete after ->
let OmniCpp_MayCompleteArrow = 1 
" autocomplete after ::
let OmniCpp_MayCompleteScope = 1 
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

