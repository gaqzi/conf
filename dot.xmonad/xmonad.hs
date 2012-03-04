import XMonad
import XMonad.Config.Gnome
import XMonad.Util.EZConfig

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    ])

main = do
  xmonad $ gnomeConfig {
    terminal = "urxvt",
    modMask = mod4Mask,
    manageHook = myManageHook
    }
    `additionalKeysP`
    [ ("M-p", spawn "dmenu_run -b")
    ]
                     -- `additionalKeys`
                     -- [ ((mod4Mask, xK_p), spawn "dmenu_run -b") -- dmenu
                     -- ]
