import XMonad
import Solarized

main = do
  xmonad defaultconfig {
      normalBorderColor = solarizedBase01
    , focusedBorderColor = solarizedRed
  }
