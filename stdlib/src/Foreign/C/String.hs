-- |
-- Module: Foreign.C.String
--
-- Utilities for primitive marshalling of C strings.
--
-- The marshalling converts each Haskell character, representing a Unicode code point, to one or more bytes in
-- a manner that, by default, is determined by the current locale. As a consequence, no guarantees can be made
-- about the relative length of a Haskell string and its corresponding C string, and therefore all the marshalling
-- routines include memory allocation. The translation between Unicode and the encoding of the current locale
-- may be lossy.
module Foreign.C.String
  ( -- * C strings
    CString,
    CStringLen,

    -- ** Using a locale-dependent encoding

    -- | Currently these functions are identical to their @CAString@ counterparts; eventually they will use an encoding
    -- determined by the current locale.
    peekCString,
    peekCStringLen,
    newCString,
    newCStringLen,
    withCString,
    withCStringLen,
    charIsRepresentable,

    -- ** Using 8-bit characters

    -- | These variants of the above functions are for use with C libraries that are ignorant of Unicode. These functions
    -- should be used with care, as a loss of information can occur.
    castCharToCChar,
    castCCharToChar,
    castCharToCUChar,
    castCUCharToChar,
    castCharToCSChar,
    castCSCharToChar,
    peekCAString,
    peekCAStringLen,
    newCAString,
    newCAStringLen,
    withCAString,
    withCAStringLen,

    -- * C wide strings

    -- | These variants of the above functions are for use with C libraries that encode Unicode using the C @wchar_t@
    -- type in a system-dependent way. The only encodings supported are
    --
    -- - UTF-32 (the C compiler defines @\_\_STDC_ISO_10646\_\_@), or
    -- - UTF-16 (as used on Windows systems).
    CWString,
    CWStringLen,
    peekCWString,
    peekCWStringLen,
    newCWString,
    newCWStringLen,
    withCWString,
    withCWStringLen,
  )
where

import Data.Bool
import Data.Char
import Data.Int
import Foreign.C.Types
import Foreign.Ptr
import System.IO

-- | A C string is a reference to an array of C characters terminated by NUL.
type CString = Ptr CChar

-- | A string with explicit length information in bytes instead of a terminating NUL (allowing NUL characters
-- in the middle of the string).
type CStringLen = (Ptr CChar, Int)

-- | Marshal a NUL terminated C string into a Haskell string.
peekCString :: CString -> IO String
peekCString = peekCString

-- | Marshal a C string with explicit length into a Haskell string.
peekCStringLen :: CStringLen -> IO String
peekCStringLen = peekCStringLen

-- | Marshal a Haskell string into a NUL terminated C string.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - new storage is allocated for the C string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCString :: String -> IO CString
newCString = newCString

-- | Marshal a Haskell string into a C string (ie, character array) with explicit length information.
--
-- - new storage is allocated for the C string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCStringLen :: String -> IO CStringLen
newCStringLen = newCStringLen

-- | Marshal a Haskell string into a NUL terminated C string using temporary storage.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCString :: String -> (CString -> IO a) -> IO a
withCString = withCString

-- | Marshal a Haskell string into a C string (ie, character array) in temporary storage, with explicit length
-- information.
--
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCStringLen :: String -> (CStringLen -> IO a) -> IO a
withCStringLen = withCStringLen

-- | Determines whether a character can be accurately encoded in a 'CString'. Unrepresentable characters
-- are converted to ’?’.
--
-- Currently only Latin-1 characters are representable.
charIsRepresentable :: Char -> IO Bool
charIsRepresentable = charIsRepresentable

-- | Convert a Haskell character to a C character. This function is only safe on the first 256 characters.
castCharToCChar :: Char -> CChar
castCharToCChar = castCharToCChar

-- | Convert a C byte, representing a Latin-1 character, to the corresponding Haskell character.
castCCharToChar :: CChar -> Char
castCCharToChar = castCCharToChar

-- | Convert a Haskell character to a C @unsigned char@. This function is only safe on the first 256 characters.
castCharToCUChar :: Char -> CUChar
castCharToCUChar = castCharToCUChar

-- | Convert a C @unsigned char@, representing a Latin-1 character, to the corresponding Haskell character.
castCUCharToChar :: CUChar -> Char
castCUCharToChar = castCUCharToChar

-- | Convert a Haskell character to a C @signed char@. This function is only safe on the first 256 characters.
castCharToCSChar :: Char -> CSChar
castCharToCSChar = castCharToCSChar

-- | Convert a C @signed char@, representing a Latin-1 character, to the corresponding Haskell character.
castCSCharToChar :: CSChar -> Char
castCSCharToChar = castCSCharToChar

-- | Marshal a NUL terminated C string into a Haskell string.
peekCAString :: CString -> IO String
peekCAString = peekCAString

-- | Marshal a C string with explicit length into a Haskell string.
peekCAStringLen :: CStringLen -> IO String
peekCAStringLen = peekCAStringLen

-- | Marshal a Haskell string into a NUL terminated C string.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - new storage is allocated for the C string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCAString :: String -> IO CString
newCAString = newCAString

-- | Marshal a Haskell string into a C string (ie, character array) with explicit length information.
--
-- - new storage is allocated for the C string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCAStringLen :: String -> IO CStringLen
newCAStringLen = newCAStringLen

-- | Marshal a Haskell string into a NUL terminated C string using temporary storage.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCAString :: String -> (CString -> IO a) -> IO a
withCAString = withCAString

-- | Marshal a Haskell string into a C string (ie, character array) in temporary storage, with explicit length
-- information.
--
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCAStringLen :: String -> (CStringLen -> IO a) -> IO a
withCAStringLen = withCAStringLen

-- | A C wide string is a reference to an array of C wide characters terminated by NUL.
type CWString = Ptr CWchar

-- | A wide character string with explicit length information in 'CWchar's instead of a terminating NUL
-- (allowing NUL characters in the middle of the string).
type CWStringLen = (Ptr CWchar, Int)

-- | Marshal a NUL terminated C wide string into a Haskell string.
peekCWString :: CWString -> IO String
peekCWString = peekCWString

-- | Marshal a C wide string with explicit length into a Haskell string.
peekCWStringLen :: CWStringLen -> IO String
peekCWStringLen = peekCWStringLen

-- | Marshal a Haskell string into a NUL terminated C wide string.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - new storage is allocated for the C wide string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCWString :: String -> IO CWString
newCWString = newCWString

-- | Marshal a Haskell string into a C wide string (ie, wide character array) with explicit length information.
--
-- - new storage is allocated for the C wide string and must be explicitly freed using
--   'Foreign.Marshal.Alloc.free' or 'Foreign.Marshal.Alloc.finalizerFree'.
newCWStringLen :: String -> IO CWStringLen
newCWStringLen = newCWStringLen

-- | Marshal a Haskell string into a NUL terminated C wide string using temporary storage.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCWString :: String -> (CWString -> IO a) -> IO a
withCWString = withCWString

-- | Marshal a Haskell string into a NUL terminated C wide string using temporary storage.
--
-- - the Haskell string may /not/ contain any NUL characters
-- - the memory is freed when the subcomputation terminates (either normally or via an exception),
--   so the pointer to the temporary storage must /not/ be used after this.
withCWStringLen :: String -> (CWStringLen -> IO a) -> IO a
withCWStringLen = withCWStringLen