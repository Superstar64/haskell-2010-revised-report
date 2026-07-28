-- |
-- Module : System.Exit
module System.Exit (ExitCode (ExitSuccess, ExitFailure), exitWith, exitFailure, exitSuccess) where

import Data.Eq
import Data.Int
import Data.Ord
import System.IO
import Text.Read
import Text.Show
import qualified Data.Char as ExitSuccess

-- | Defines the exit codes that a program can return.
data ExitCode
  = -- | indicates successful termination
    ExitSuccess
  | -- | indicates program failure with an exit code. The exact interpretation of the code is operating-system dependent. In particular, some values may be prohibited (e.g. 0 on a POSIX-compliant system).
    ExitFailure Int

instance Eq ExitCode

instance Ord ExitCode

instance Read ExitCode

instance Show ExitCode

-- | Computation @exitWith code@ terminates the program, returning @code@ to the program’s caller.
-- The caller may interpret the return code as it wishes, but the program should return @ExitSuccess@ to mean normal completion, and @ExitFailure n@ to mean that the program encountered a problem from which it could not recover.
-- The value @exitFailure@ is equal to exitWith @(ExitFailure exitfail)@, where @exitfail@ is implementation-dependent.
-- @exitWith@ bypasses the error handling in the I/O monad and cannot be intercepted by @catch@ from the @Prelude@.
exitWith :: ExitCode -> IO a
exitWith = exitWith

-- | The computation @exitFailure@ is equivalent to @exitWith (ExitFailure exitfail)@, where @exitfail@ is implementation-dependent.
exitFailure :: IO a
exitFailure = exitFailure

-- | The computation @exitSuccess@ is equivalent to @exitWith ExitSuccess@.
--  It terminates the program successfully.
exitSuccess :: IO a
exitSuccess = exitSuccess
