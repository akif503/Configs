import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.RefocusLast
import XMonad.Hooks.UrgencyHook

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.Focus

import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS (nextWS, prevWS)
import XMonad.Hooks.ManageHelpers (doRectFloat)
import XMonad.StackSet (RationalRect (..))
import Data.Ratio 
-- import XMonad.Layout.SimpleFloat

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh =<< xmobar myConfig
-- main = xmonad . ewmhFullscreen . ewmh $ myConfig

myManageHook = composeAll
    [ className =? "jetbrains-clion" --> doFloat
    , className =? "Anki" --> doFloat >> (doRectFloat (RationalRect (1 % 3) (1 % 4) (1 % 3) (1 % 2)))
    , title =? "Parse Tree Inspector" --> doFloat
    ]


-- Command to create a scratch alacritty terminal (differentiated from the rest of the open terminals by the title=scratch_term)
createScratchTerminal, createScratchNotepad, scratchNotepad :: String
openAlacrittyWithTitle :: String -> String
scratchNotepad = "$(echo \"/home/akif/Scratch/\"$(date +\"%d-%b-%G\")\".md\")"
openAlacrittyWithTitle title = "alacritty -o \"window.title=" ++ title ++ "\" -o \"window.dynamic_title=false\""

createScratchTerminal = openAlacrittyWithTitle "scratch_term"
createScratchNotepad = (openAlacrittyWithTitle "scratch_notepad") ++ " -e \"nvim\" \"" ++ scratchNotepad ++ "\""
-- NS "<alias>" "<command>" <match process> <floating option>
scratchpads = 
    [ NS "scratch_term" createScratchTerminal (title =? "scratch_term") defaultFloating
    , NS "scratch_notepad" createScratchNotepad (title =? "scratch_notepad") defaultFloating
    ]

myConfig = def
    {
    -- modMask = mod4Mask -- rebind Mod to Super/Windows key
      terminal = "alacritty" -- set default terminal
    , handleEventHook = fullscreenEventHook
    , layoutHook = myLayout
    , logHook = refocusLastLogHook >> nsHideOnFocusLoss scratchpads
              -- enable hiding for all of @myScratchpads@
    , manageHook = myManageHook <+> namedScratchpadManageHook scratchpads
    } 
    `additionalKeysP`
    [ ("M-d", spawn "alacritty -o \"window.position.x=100\"")
    , ("M-c", spawn "clion.sh")
    -- , ("M1-<Tab>", namedScratchpadAction scratchpads "scratch_term")
    -- , ("M1-q", namedScratchpadAction scratchpads "scratch_term")
    , ("M-n", namedScratchpadAction scratchpads "scratch_notepad")
    , ("<XF86MonBrightnessUp>", spawn "xbacklight +10")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight -10")
    , ("<XF86AudioMute>", spawn "amixer sset Master toggle && ~/.config/_scripts/getVolume")
    , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 10%- && ~/.config/_scripts/getVolume")
    , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 10%+ && ~/.config/_scripts/getVolume")
    , ("<Print>", spawn "maim -s | xclip -selection clipboard -t image/png") -- This command takes an SS and saves it on the clipboard
    , ("M-f", spawn "firefox")
    ]

-- The layoutHook defines all of the layouts, each of the layout is seperated using |||
-- The default layout is:
-- layoutHook = tiled ||| Mirror tiled ||| Full
--     where
--         tiled   = Tall nmaster delta ratio
--         nmaster = 1      -- Default number of windows in the master pane
--         ratio   = 1/2    -- Default proportion of screen occupied by master pane
--         delta   = 3/100  -- Percent of screen to increment by when resizing panes

myLayout = smartBorders $ (withWindowGaps tiled) ||| Full
    where
        tiled   = Tall nmaster delta ratio
        nmaster = 1      -- Default number of windows in the master pane
        ratio   = 1/2    -- Default proportion of screen occupied by master pane
        delta   = 3/100  -- Percent of screen to increment by when resizing panes
        -- withGaps = gaps [(U,15), (D,15), (R,15), (L,15)] -- Adds constant gaps on all side screen
        withWindowGaps = spacingRaw True (Border 0 2 2 0) True (Border 0 2 2 0) True
