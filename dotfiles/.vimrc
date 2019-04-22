set runtimepath+=~/.config/vim_runtime

source ~/.config/vim_runtime/vimrcs/basic.vim
source ~/.config/vim_runtime/vimrcs/filetypes.vim
source ~/.config/vim_runtime/vimrcs/plugins_config.vim
source ~/.config/vim_runtime/vimrcs/extended.vim

try
source ~/.config/vim_runtime/custom.vim
catch
endtry
