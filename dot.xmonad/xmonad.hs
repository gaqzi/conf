import XMonad
import XMonad.Config.Gnome
import XMonad.Actions.Submap
import XMonad.Layout.NoBorders

import Control.Arrow
import Data.Bits
import qualified Data.Map as M

main :: IO ()
main = do
  xmonad $ gnomeConfig
    { terminal = "urxvt",
      modMask = mod4Mask,
      keys = addPrefix (controlMask, xK_m) (keys gnomeConfig),
      -- smartBorders hides the border for mplayer
      layoutHook = smartBorders $ layoutHook gnomeConfig }

addPrefix p ms conf =
  M.singleton p . submap $ M.mapKeys (first chopMod) (ms conf)
  where
  mod = modMask conf
  chopMod = (.&. complement mod)
