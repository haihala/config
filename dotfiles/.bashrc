# Add ~/bin to path
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi

XDG_CURRENT_DESKTOP="sway"
. "$HOME/.cargo/env"

complete -C /usr/bin/terraform terraform
