# ~/.bashrc


# this .bashrc file contains content of 
# andreas textor .bashrc available at
# https://github.com/atextor/dotfiles.git

# set editor for e.g. mutt, svn
export EDITOR=vim
# the location for the R history file (required by .Rprofile)
export R_HISTFILE="~/.R/"
# the location ofh the R libraries
export R_LIBS="~/.R/library"

# set an alias for mutt
alias mutt='mutt -F ~/.mutt/.muttrc'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

PATH=$PATH:/home/michael/Software/bin:/opt/rstudio/bin

# function to check where am i
function whereami() {
  if [ $HOSTNAME = "prefect" ]; then echo "home"; exit; fi
  if [ $HOSTNAME = "beeblebrox" ]; then echo "notebook"; exit; fi
  if [ $HOSTNAME = "andorra" ] || [ $HOSTNAME = "ramssys" ] || [ $HOSTNAME = "uhu"] || [ $HOSTNAME = "cu" ] ; then echo "fu"; fi
  if [ $HOSTNAME = "gruenau" ] || [ $HOSTNAME = "pandora" ] ; then echo "hu"; fi
}

# Locales for units. Use german UTF-8 if available,
# otherwise english UTF-8 if available.
function unit_locale() {
if ! which locale >/dev/null; then exit; fi
if locale -a | grep de_DE.utf8 >/dev/null; then
	echo "de_DE.utf8"
elif locale -a | grep en_US.utf8 >/dev/null; then
	echo "en_US.utf8"
else
	echo "C"
fi
}

# Locales for messages. Use english UTF-8 if available.
function message_locale() {
if ! which locale >/dev/null; then exit; fi
if locale -a | grep en_US.utf8 >/dev/null; then
	echo "en_US.utf8"
else
	echo "C"
fi
}

# Locales. Only set if available. The functions (see above)
# determine if the locales are available and fall back to C if not.
# Messages in english please.
msg_loc=$(message_locale)

# Time, date, papersize etc. in german please.
unt_loc=$(unit_locale)
unset LC_ALL
export LANG=$msg_loc
export LANGUAGE=$msg_loc
export LC_CTYPE=$msg_loc
export LC_NUMERIC=$msg_loc
export LC_MESSAGES=$msg_loc
export LC_NAME=$msg_loc

export LC_COLLATE=$unt_loc
export LC_ADDRESS=$unt_loc
export LC_TELEPHONE=$unt_loc
export LC_MEASUREMENT=$unt_loc
export LC_IDENTIFICATION=$unt_loc
export LC_TIME=$unt_loc
export LC_MONETARY=$unt_loc
export LC_PAPER=$unt_loc

# Find file by pattern
function ff() {
find . -type f -iname '*'$*'*' -ls ;
}

# setup for simulation environment on "knecht.imp.fu-berlin.de"
CURRENT_HOSTNAME=$(uname -n)
EXPECTED_HOSTNAME="knecht"

if [ $CURRENT_HOSTNAME == $EXPECTED_HOSTNAME ]; then
  FREY_SOFTWARE="/home/fenn/frey/NO_BACKUP/Software/build"
  MY_GXX_HOME="${FREY_SOFTWARE}/rtf"
  OMNETPP_HOME="${FREY_SOFTWARE}/omnetpp-4.3"
  ARA_SIM_HOME="${FREY_SOFTWARE}/ara-sim"
  PYTHON_HOME="${FREY_SOFTWARE}/python"
  export PATH="${MY_GXX_HOME}/bin:${OMNETPP_HOME}/bin:${PYTHON_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${MY_GXX_HOME}/lib:${MY_GXX_HOME}/lib64:${ARA_SIM_HOME}/src:${ARA_SIM_HOME}/inetmanet/src:${OMNETPP_HOME}/lib"
fi

