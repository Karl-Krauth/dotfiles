set -x PATH ~/.bin/anaconda3/bin $PATH
set -x PATH ~/.bin/nvim/bin $PATH
set -x PATH ~/.bin/ $PATH
set -x PATH /snap/bin $PATH
set -x COLORTERM truecolor
alias vim "nvim"
direnv hook fish | source
