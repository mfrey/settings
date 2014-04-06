import XMonad
import Data.Monoid
import Data.Ratio ((%))
import System.Exit
import System.IO
import Solarized
import XMonad.Actions.FloatKeys
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run
import XMonad.Util.Themes
import XMonad.Util.Scratchpad
import XMonad.Layout.Fullscreen
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Config.Gnome

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- set terminal to unicode rxvt 
myTerminal = "urxvt" 

-- focus should follow the mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- width of the window border in pixel
myBorderWidth = 3

-- set modkey to the left alt key
myModMask = mod1Mask

-- set the number of workspaces 
myWorkspaces = ["1","2","3","4","5","6","7","8","9"] 

-- execute arbitrary actions and WindowSet manipulations when managing a new window
myManageHook = composeAll
    ([ className =? "MPlayer" --> doFloat
    , className =? "Gimp" --> doFloat
    , className =? "VirtualBox" --> doFloat
    , className =? "Pinentry-gtk2" --> doFloat
    , resource =? "desktop_window" --> doIgnore
    , resource =? "kdesktop" --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)
    , isDialog --> doCenterFloat
    ]) <+> manageScratchPad

-- scratchpad management
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    -- terminal height, 10 %
    h = 0.1 
    -- terminal width, 100 %
    w = 1 
    -- distance from top edge, 90 %
    t = 1 - h 
    -- distance from left edge, 0 %
    l = 1 - w 

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- lock the screen (xscreensaver daemon must be running)
    , ((modm , xK_z), spawn "xscreensaver-command lock")
    -- restart xmonad 
    , ((modm , xK_q), spawn "xmonad --recompile; xmonad --restart")
    -- start demnu (application launcher) with yeganesh (script resides in .xmonad/bin)
    , ((modm , xK_p), spawn "dmenu-yeganesh")
    -- quit xmonad
    , ((modm .|. shiftMask, xK_q ), io (exitWith ExitSuccess))
    ]++
    --- switch workspace by alt + f1 ... f10 key
    [ ((modm, k), windows $ W.greedyView i)
        | (i, k) <- zip myWorkspaces workspaceKeys
    ] ++
    -- mod + f1 ... f10 moves window to workspace and switches to that workspace
    [ ((mod4Mask, k), (windows $ W.shift i) >> (windows $ W.greedyView i))
        | (i, k) <- zip myWorkspaces workspaceKeys
    ]
    where workspaceKeys = [xK_F1 .. xK_F10]

myLayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    -- the default number of windows in the master pane
    nmaster = 1
    -- default proportion of screen occupied by master pane
    ratio = 1/2
    -- percentage of screen to increment by when resizing panes
    delta = 3/100

myLayouts = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2))) |||
    noBorders (fullscreenFull Full)

-- border color for unfocused windows
myNormalBorderColor = solarizedBase03
-- border color for focused windows
myFocusedBorderColor = solarizedBase00

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  -- xmonad $ defaultconfig 
  xmonad $ gnomeConfig 
      { terminal           = myTerminal
      , modMask            = myModMask
      , borderWidth        = myBorderWidth
      , focusFollowsMouse  = myFocusFollowsMouse
      , workspaces         = myWorkspaces
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor

      -- key bindings
      , keys                 = myKeys

      -- xmobar settings
      , manageHook         = myManageHook
      , layoutHook         = smartBorders (myLayouts)
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput       = hPutStrLn xmproc
          , ppTitle        = xmobarColor "green" "" . shorten 50
          , ppLayout       = const ""
          }
      }
