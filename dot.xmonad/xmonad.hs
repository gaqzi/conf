import XMonad
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Script
import XMonad.Actions.Submap
import XMonad.Layout.NoBorders
import Control.Arrow
import Data.Bits
import XMonad.Util.Run(spawnPipe, safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

-- startup :: X ()
-- myStartupHook = do
--   spawn "/usr/bin/xsetroot -solid black"
--   spawn "/home/ba/bin/trayer-launcher"

main :: IO ()
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/ba/.xmobarrc"
  -- spawn "/home/ba/bin/trayer-launcher"
  xmonad $ defaultConfig
    { terminal = "urxvt",
      modMask = mod4Mask,
      keys = addPrefix (controlMask, xK_m) (keys defaultConfig),
      layoutHook = smartBorders $ avoidStruts $ layoutHook defaultConfig,
      manageHook = manageDocks XMonad.<+> manageHook defaultConfig,
      logHook = dynamicLogWithPP xmobarPP
                       { ppOutput = hPutStrLn xmproc
                       , ppTitle = xmobarColor "green" "" . shorten 50
                       },
      startupHook = execScriptHook "startup"
      --   spawn "xsetroot -solid black"
      --   spawn "/home/ba/bin/trayer-launcher"
    }

addPrefix p ms conf =
  M.singleton p . submap $ M.mapKeys (first chopMod) (ms conf)
  where
    mod = modMask conf
    chopMod = (.&. complement mod)

