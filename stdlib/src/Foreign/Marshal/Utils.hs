-- |
-- Module: Foreign.Marshal.Utils
module Foreign.Marshal.Utils
  ( -- * General marshalling utilities
    -- ** Combined allocation and marshalling
    with,
    new,
    -- ** Marshalling of Boolean values (non-zero corresponds to True)
    fromBool,
    toBool,
    -- ** Marshalling of Maybe values
    maybeNew,
    maybeWith,
    maybePeek,
    -- ** Marshalling lists of storable objects
    withMany,
    -- ** Haskellish interface to memcpy and memmove

    -- | (argument order: destination, source)
    copyBytes,
    moveBytes,
  )
where

import Data.Bool
import Data.Int
import Data.Maybe
import Foreign.Ptr
import Foreign.Storable
import NumHierarchy
import System.IO

-- | @with val f@ executes the computation @f@, passing as argument a pointer to a temporarily allocated
-- block of memory into which @val@ has been marshalled (the combination of 'alloca' and 'poke').
--
-- The memory is freed when @f@ terminates (either normally or via an exception), so the pointer passed to
-- @f@ must not be used after this.
with :: (Storable a) => a -> (Ptr a -> IO b) -> IO b
with = with

-- | Allocate a block of memory and marshal a value into it (the combination of 'malloc' and 'poke'). The
-- size of the area allocated is determined by the 'Foreign.Storable.sizeOf' method from the instance
-- of 'Storable' for the appropriate type.
--
-- The memory may be deallocated using 'Foreign.Marshal.Alloc.free' or
-- 'Foreign.Marshal.Alloc.finalizerFree' when no longer required.
new :: (Storable a) => a -> IO (Ptr a)
new = new

-- | Convert a Haskell 'Bool' to its numeric representation
fromBool :: (Num a) => Bool -> a
fromBool = fromBool

-- | Convert a Boolean in numeric representation to a Haskell value
toBool :: (Num a) => a -> Bool
toBool = toBool

-- | Allocate storage and marshal a storable value wrapped into a 'Maybe'
--
--  - the 'nullPtr' is used to represent 'Nothing'
maybeNew :: (a -> IO (Ptr a)) -> Maybe a -> IO (Ptr a)
maybeNew = maybeNew

-- | Converts a @withXXX@ combinator into one marshalling a value wrapped into a 'Maybe', using 'nullPtr'
-- to represent 'Nothing'.
maybeWith :: (a -> (Ptr b -> IO c) -> IO c) -> Maybe a -> (Ptr b -> IO c) -> IO c
maybeWith = maybeWith

-- | Convert a peek combinator into a one returning 'Nothing' if applied to a 'nullPtr'
maybePeek :: (Ptr a -> IO b) -> Ptr a -> IO (Maybe b)
maybePeek = maybePeek

-- | Replicates a @withXXX@ combinator over a list of objects, yielding a list of marshalled objects
withMany :: (a -> (b -> res) -> res) -> [a] -> ([b] -> res) -> res
withMany = withMany

-- | Copies the given number of bytes from the second area (source) into the first (destination); the copied
-- areas may /not/ overlap
copyBytes :: Ptr a -> Ptr a -> Int -> IO ()
copyBytes = copyBytes

-- | Copies the given number of bytes from the second area (source) into the first (destination); the copied
-- areas /may/ overlap
moveBytes :: Ptr a -> Ptr a -> Int -> IO ()
moveBytes = moveBytes