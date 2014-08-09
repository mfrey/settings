# ~/.bashrc


# this .bashrc file contains content of 
# andreas textor .bashrc available at
# https://github.com/atextor/dotfiles.git

# set editor for e.g. mutt, svn
export EDITOR=vim
# the location for the R history file (required by .Rprofile)
export R_HISTFILE="~/.Rhistory"
# the location ofh the R libraries
export R_LIBS="~/.R/library"

# set an alias for mutt
alias mutt='mutt -F ~/.mutt/muttrc'
# set an truecrypt alias
alias tc1='truecrypt --fs-options=users,uid=$(id -u),gid=$(id -g),fmask=0113,dmask=0002 --mount /dev/sde1"" /mnt/truecrypt'
# always get the line numbers if using grep
alias grep='grep -n'

# alias for hu openvpn
alias hu='sudo /usr/sbin/openvpn  --config /etc/openvpn/wlanin.conf'

# enable core dumps
ulimit -c unlimited

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# let's first check if certain directories are existent before we
# add them to the $PATH variable
function add_directory_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

RUBY_GEM_DIRECTORY=$HOME/.gem/ruby/2.1.0/bin/
add_directory_to_path $RUBY_GEM_DIRECTORY

COVERITY_DIRECTORY=$HOME/Software/build/cov-analysis-linux64-7.5.0/bin
add_directory_to_path $COVERITY_DIRECTORY

OMNETPP_DIRECTORY=$HOME/Software/omnetpp-4.3/bin
add_directory_to_path $OMNETPP_DIRECTORY

LOCAL_SOFTWARE_DIRECTORY=$HOME/Software/bin
add_directory_to_path $LOCAL_SOFTWARE_DIRECTORY

GARMIN_DEV_DIRECTORY=$HOME/Software/build/garmin-dev
add_directory_to_path $GARMIN_DEV_DIRECTORY


# function to check where am i
function whereami() {
  if [ $HOSTNAME = "prefect" ]; then echo "home"; exit; fi
  if [ $HOSTNAME = "beeblebrox" ]; then echo "notebook"; exit; fi
  if [ $HOSTNAME = "andorra" ] || [ $HOSTNAME = "ramssys" ] || [ $HOSTNAME = "uhu"] || [ $HOSTNAME = "cu" ] || [ $HOSTNAME = "knecht" ]; then echo "fu"; fi
  if [ $HOSTNAME = "gruenau" ] || [ $HOSTNAME = "pandora" ] || [ $HOSTNAME = "jupiter" ]; then echo "hu"; fi
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

# usage example: translate de example (first parameter is the language, second
# the actual word/sentence
function translate() {
wget -U "Mozilla/5.0" -qO- "http://translate.google.com/translate_a/t?client=t&text=$2&sl=auto&tl=$1" | sed 's/\[\[\[\"//' | cut -d \" -f 1
}

# the variable (if applicable) points to our build enviroment (only necessary
# for outdated systems)
ALTERNATIVE_BUILD_ENVIRONMENT=""

# if we are on a specific host, we have to set the path to our own custom build
# made build environment
case $HOSTNAME in
  "knecht") ALTERNATIVE_BUILD_ENVIRONMENT="/storage/mi/frey/Software/build"
  setBuildEnvironment
  ;;
  "jupiter") ALTERNATIVE_BUILD_ENVIRONMENT="/vol/home-vol1/simulant/frey"
  setBuildEnvironment
  ;;
  "uhu") ALTERNATIVE_BUILD_ENVIRONMENT="/home/mfrey/testbed/software"
  setBuildEnvironment
  ;;
esac

# this function sets a few variables for systems where we have built our own gcc
# toolchain and different other tools (e.g. valgrind, gdb, python, etc.)
function setBuildEnvironment() {
MY_GXX_HOME="${ALTERNATIVE_BUILD_ENVIRONMENT}/rtf"
OMNETPP_HOME="${ALTERNATIVE_BUILD_ENVIRONMENT}/omnetpp-4.3"
ARA_SIM_HOME="${ALTERNATIVE_BUILD_ENVIRONMENT}/ara-sim"
PYTHON_HOME="${ALTERNATIVE_BUILD_ENVIRONMENT}/python"
export PATH="${MY_GXX_HOME}/bin:${OMNETPP_HOME}/bin:${PYTHON_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${MY_GXX_HOME}/lib:${MY_GXX_HOME}/lib64:${ARA_SIM_HOME}/src:${ARA_SIM_HOME}/inetmanet/src:${OMNETPP_HOME}/lib"
}

# this function allows to execute bash functions using sudo. this code is from
# https://stackoverflow.com/questions/9448920/how-can-i-execude-bash-function-using-sudo
function execsudo () {
    # use underscores to remember it's been passed
    local _funcname_="$1"

    # array containing all params passed here
    local params=( "$@" )               
    # temporary file
    local tmpfile="/dev/shm/$RANDOM"    
    # content of the temporary file
    local filecontent                   
    # regular expression
    local regex                         
    # function source
    local func                          

    # shift the first param (which is the name of the function) and
    # remove first element
    unset params[0]              

    # working on the temporary file:
    content="#!/bin/bash\n\n"

    # write the params array
    content="${content}params=(\n"

    regex="\s+"
    for param in "${params[@]}"
    do
        if [[ "$param" =~ $regex ]]
            then
                content="${content}\t\"${param}\"\n"
            else
                content="${content}\t${param}\n"
        fi
    done

    content="$content)\n"
    echo -e "$content" > "$tmpfile"

    # append the function source
    echo "#$( type "$_funcname_" )" >> "$tmpfile"
    # append the call to the function
    echo -e "\n$_funcname_ \"\${params[@]}\"\n" >> "$tmpfile"

    # execute the temporary file with sudo
    sudo bash "$tmpfile"
    rm "$tmpfile"
}

# it is quite annoying if coredumps are written to systemd, so we simply set the
# core dump pattern to /tmp
function set_core_dump_pattern () {
    echo /tmp/core-%p-%u-%g-%s-%t-%e.core > /proc/sys/kernel/core_pattern
}

# asks a y/n question. Usage: if ask "something"; then ... ; fi
function ask() {
    echo -n "$@" '[Y/n] ' ; read ans
    case "$ans" in
        n*|N*) return 1 ;;
        *) return 0 ;;
    esac
}

# require can be used by other functions to make sure that certain commands
# exist before a whole process of things is started (which potentially leaves temp
# files and such)
function require() {
    which "$1" &>/dev/null
    if [ "x$?" = "x0" ]; then return 0; fi
    if [ "x$2" = "xquiet" ]; then return 1; fi
    if ask "Command not found: $1. Continue?"; then return 0; fi
    return 1
}

# This function (name compulsory) looks up a command when no alias or binary is
# found
# on the path. This wraps different lookup tools for Arch Linux and Ubuntu, and
# uses
# the best available tool.
function command_not_found_handle() {
    if [ -x /usr/bin/cnf-lookup ]; then
        # Arch Linux: command-not-found (from AUR)
        /usr/bin/cnf-lookup $1
        return $?
    elif [ -x /usr/bin/pkgfile ]; then
        # Arch Linux: pkgtools (from community repo)
        # There's also /usr/share/pkgtools/pkgfile-hook.bash which could be sourced,
        # but I like to have the logic in one place
        local pkgs="$(pkgfile -b -v -- "$1")"
        if [ ! -z "$pkgs" ]; then
            echo -e "\n$1 may be found in the following packages:\n$pkgs"
            return 0
        fi
    elif [ -x /usr/lib/command-not-found ]; then
        # Ubuntu's standard command-not-found handler
        /usr/bin/python /usr/lib/command-not-found -- $1
        return $?
    elif [ -x /usr/share/command-not-found ]; then
        # Ubuntu's standard command-not-found handler
        /usr/bin/python /usr/share/command-not-found -- $1
        return $?
    fi
    # Nothing :/
    printf "bash: $(gettext bash "%s: command not found")\n" $1 >&2
    return 127
}

export -f set_core_dump_pattern
export -f execsudo

# this actually makes it easier to debug libara and OMNeT++ specific code
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/Software/omnetpp-4.3/lib/:$HOME/Desktop/Projekte/libara/src
# OMNeT++ wants to know the path to the tcl libraries 
export TCL_LIBRARY=/usr/lib/tcl8.6

# enable 256 color terminal for tmux
[ -n "$TMUX" ] && export TERM=screen-256color
