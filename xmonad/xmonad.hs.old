import XMonad
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Script
import XMonad.Actions.Submap
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import Control.Arrow
import Data.Bits
import XMonad.Util.Run(spawnPipe, safeSpawn)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

import XMonad.Layout.Cross

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
      layoutHook = onWorkspace "9" gimp $ smartBorders $ avoidStruts $ layoutHook defaultConfig,
      manageHook = manageDocks XMonad.<+> manageHook defaultConfig,
      logHook = dynamicLogWithPP xmobarPP
                       { ppOutput = hPutStrLn xmproc
                       , ppTitle = xmobarColor "green" "" . shorten 50
                       },
      startupHook = execScriptHook "startup"
      --   spawn "xsetroot -solid black"
      --   spawn "/home/ba/bin/trayer-launcher"
    }
    where
      gimp = withIM (0.11) (Role "gimp-toolbox") $
             reflectHoriz $
             withIM (0.15) (Role "gimp-dock") Full

addPrefix p ms conf =
  M.singleton p . submap $ M.mapKeys (first chopMod) (ms conf)
  where
    mod = modMask conf
    chopMod = (.&. complement mod)

