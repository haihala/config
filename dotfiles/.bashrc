# Add ~/bin to path
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi

. "$HOME/.cargo/env"

complete -C /usr/bin/terraform terraform
