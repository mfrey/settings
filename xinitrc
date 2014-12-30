os=`uname -s`

if ["$os" == Darwin"]; then
  monitor=`xrandr | grep -i edp | cut -d " " -f 1`
  xrandr --newmode  "1440x900_60.00"  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync
  xrandr --addmode $monitor 1440x900_60.00
  xrandr --output $monitor --mode 1440x900_60.00
else
  if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
    done
    unset f

  xrdb -merge ~/.Xresources
fi

exec xmonad
