-- |
-- Module: System.Environment
module System.Environment
  ( getArgs,
    getProgName,
    getEnv,
  )
where

import Data.Char
import System.IO

-- | Computation @getArgs@ returns a list of the program’s command line arguments (not including the program name).
getArgs :: IO [String]
getArgs = getArgs

-- | Computation @getProgName@ returns the name of the program as it was invoked.
-- However, this is hard-to-impossible to implement on some non-Unix OSes, so instead, for maximum portability, we just return the leafname of the program as invoked. Even then there are some differences between platforms: on Windows, for example, a program invoked as foo is probably really @FOO.EXE@, and that is what @getProgName@ will return.
getProgName :: IO String
getProgName = getProgName

-- | Computation @getEnv var@ returns the value of the environment variable @var@.
--
-- This computation may fail with:
--
-- - 'System.IO.Error.isDoesNotExistError' if the environment variable does not exist.
getEnv :: String -> IO String
getEnv = getEnv
