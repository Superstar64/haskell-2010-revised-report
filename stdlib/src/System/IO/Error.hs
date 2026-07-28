module System.IO.Error
  ( -- * I/O errors
    IOError,
    userError,
    mkIOError,
    annotateIOError,

    -- * Classifying I/O errors
    isAlreadyExistsError,
    isDoesNotExistError,
    isAlreadyInUseError,
    isFullError,
    isEOFError,
    isIllegalOperation,
    isPermissionError,
    isUserError,

    -- * Attributes of I/O errors
    ioeGetErrorString,
    ioeGetHandle,
    ioeGetFileName,

    -- * Types of I/O error
    IOErrorType,
    alreadyExistsErrorType,
    doesNotExistErrorType,
    alreadyInUseErrorType,
    fullErrorType,
    eofErrorType,
    illegalOperationErrorType,
    permissionErrorType,
    userErrorType,

    -- * Throwing and catching I/O errors
    ioError,
    catch,
    try,
  )
where

import Data.Bool
import Data.Char
import Data.Either
import Data.Eq
import Data.Maybe
import System.IO
import Text.Show

-- | Errors of type @IOError@ are used by the @IO@ monad. This is an abstract type; the module
-- @System.IO.Error@ provides functions to interrogate and construct values of type @IOError@.
data IOError = AbstractIOError

-- | Construct an @IOError@ value with a string describing the error. The @fail@ method of the @IO@ instance of
-- the @Monad@ class raises a @userError@, thus:
--
-- @
-- instance Monad IO where
--   ...
--   fail s = ioError (userError s)
-- @
userError :: String -> IOError
userError = userError

-- | Construct an @IOError@ of the given type where the second argument describes the error location and
-- the third and fourth argument contain the file handle and file path of the file involved in the error if
-- applicable.
mkIOError :: IOErrorType -> String -> Maybe Handle -> Maybe FilePath -> IOError
mkIOError = mkIOError

-- | Adds a location description and maybe a file path and file handle to an @IOError@. If any of the file
-- handle or file path is not given the corresponding value in the @IOError@ remains unaltered.
annotateIOError :: IOError -> String -> Maybe Handle -> Maybe FilePath -> IOError
annotateIOError = annotateIOError

-- | An error indicating that an @IO@ operation failed because one of its arguments already exists.
isAlreadyExistsError :: IOError -> Bool
isAlreadyExistsError = isAlreadyExistsError

-- | An error indicating that an @IO@ operation failed because one of its arguments does not exist.
isDoesNotExistError :: IOError -> Bool
isDoesNotExistError = isDoesNotExistError

-- | An error indicating that an @IO@ operation failed because one of its arguments is a single-use resource,
-- which is already being used (for example, opening the same file twice for writing might give this error).
isAlreadyInUseError :: IOError -> Bool
isAlreadyInUseError = isAlreadyInUseError

-- | An error indicating that an @IO@ operation failed because the device is full.
isFullError :: IOError -> Bool
isFullError = isFullError

-- | An error indicating that an @IO@ operation failed because the end of file has been reached.
isEOFError :: IOError -> Bool
isEOFError = isEOFError

-- | An error indicating that an @IO@ operation failed because the operation was not possible. Any computation
-- which returns an @IO@ result may fail with @isIllegalOperation@. In some cases, an implementation
-- will not be able to distinguish between the possible error causes. In this case it should fail with
-- @isIllegalOperation@.
isIllegalOperation :: IOError -> Bool
isIllegalOperation = isIllegalOperation

-- | An error indicating that an @IO@ operation failed because the user does not have sufficient operating
-- system privilege to perform that operation.
isPermissionError :: IOError -> Bool
isPermissionError = isPermissionError

-- | A programmer-defined error value constructed using @userError@.
isUserError :: IOError -> Bool
isUserError = isUserError

ioeGetErrorString :: IOError -> String
ioeGetErrorString = ioeGetErrorString

ioeGetHandle :: IOError -> Maybe Handle
ioeGetHandle = ioeGetHandle

ioeGetFileName :: IOError -> Maybe FilePath
ioeGetFileName = ioeGetFileName

-- | An abstract type that contains a value for each variant of @IOError@.
data IOErrorType = AbstractIOErrorType

instance Eq IOErrorType

instance Show IOErrorType

-- | I/O error where the operation failed because one of its arguments already exists.
alreadyExistsErrorType :: IOErrorType
alreadyExistsErrorType = alreadyExistsErrorType

-- | I/O error where the operation failed because one of its arguments does not exist.
doesNotExistErrorType :: IOErrorType
doesNotExistErrorType = doesNotExistErrorType

-- | I/O error where the operation failed because one of its arguments is a single-use resource, which is
-- already being used.
alreadyInUseErrorType :: IOErrorType
alreadyInUseErrorType = alreadyInUseErrorType

-- | I/O error where the operation failed because the device is full.
fullErrorType :: IOErrorType
fullErrorType = fullErrorType

-- | I/O error where the operation failed because the end of file has been reached.
eofErrorType :: IOErrorType
eofErrorType = eofErrorType

-- | I/O error where the operation is not possible.
illegalOperationErrorType :: IOErrorType
illegalOperationErrorType = illegalOperationErrorType

-- | I/O error where the operation failed because the user does not have sufficient operating system privilege
-- to perform that operation.
permissionErrorType :: IOErrorType
permissionErrorType = permissionErrorType

-- | I/O error that is programmer-defined.
userErrorType :: IOErrorType
userErrorType = userErrorType

-- | Raise an IOError in the IO monad.
ioError :: IOError -> IO a
ioError = ioError

-- | The @catch@ function establishes a handler that receives any @IOError@ raised in the action protected by
-- @catch@. An @IOError@ is caught by the most recent handler established by @catch@. These handlers are
-- not selective: all @IOErrors@ are caught. Exception propagation must be explicitly provided in a handler
-- by re-raising any unwanted exceptions. For example, in
--
-- @
--  f = catch g (\\e -> if IO.isEOFError e then return [] else ioError e)
-- @
--
-- the function @f@ returns @[]@ when an end-of-file exception (cf. @isEOFError@) occurs in @g@; otherwise, the
-- exception is propagated to the next outer handler.
--
-- When an exception propagates outside the main program, the Haskell system prints the associated
-- @IOError@ value and exits the program.
catch :: IO a -> (IOError -> IO a) -> IO a
catch = catch

-- | The construct @try comp@ exposes IO errors which occur within a computation, and which are not fully
-- handled.
try :: IO a -> IO (Either IOError a)
try = try
