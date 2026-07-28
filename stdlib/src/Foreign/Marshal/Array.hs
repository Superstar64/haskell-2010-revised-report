-- |
-- Module: Foreign.Marshal.Array
--
-- The module @Foreign.Marshal.Array@ provides operations for marshalling Haskell lists into monolithic
-- arrays and vice versa. Most functions come in two flavours: one for arrays terminated by a special termination
-- element and one where an explicit length parameter is used to determine the extent of an array. The typical
-- example for the former case are C’s NUL terminated strings. However, please note that C strings should
-- usually be marshalled using the functions provided by @Foreign.C.String@ as the Unicode encoding has
-- to be taken into account. All functions specifically operating on arrays that are terminated by a special
-- termination element have a name ending on @0@—e.g., 'mallocArray' allocates space for an array of the given
-- size, whereas 'mallocArray0' allocates space for one more element to ensure that there is room for the
-- terminator.
module Foreign.Marshal.Array
  ( -- * Marshalling arrays
    -- ** Allocation
    mallocArray,
    mallocArray0,
    allocaArray,
    allocaArray0,
    reallocArray,
    reallocArray0,
    -- ** Marshalling
    peekArray,
    peekArray0,
    pokeArray,
    pokeArray0,
    -- ** Combined allocation and marshalling
    newArray,
    newArray0,
    withArray,
    withArray0,
    withArrayLen,
    withArrayLen0,
    -- ** Copying

    -- | (argument order: destination, source)
    copyArray,
    moveArray,
    -- ** Finding the length
    lengthArray0,
    -- ** Indexing
    advancePtr,
  )
where

import Data.Eq
import Data.Int
import Foreign.Ptr
import Foreign.Storable
import System.IO

-- | Allocate storage for the given number of elements of a storable type (like
-- 'Foreign.Marshal.Alloc.malloc', but for multiple elements).
mallocArray :: (Storable a) => Int -> IO (Ptr a)
mallocArray = mallocArray

-- | Like 'mallocArray', but add an extra position to hold a special termination element.
mallocArray0 :: (Storable a) => Int -> IO (Ptr a)
mallocArray0 = mallocArray0

-- | Temporarily allocate space for the given number of elements (like
-- 'Foreign.Marshal.Alloc.alloca', but for multiple elements).
allocaArray :: (Storable a) => Int -> (Ptr a -> IO b) -> IO b
allocaArray = allocaArray

-- | Like 'allocaArray', but add an extra position to hold a special termination element.
allocaArray0 :: (Storable a) => Int -> (Ptr a -> IO b) -> IO b
allocaArray0 = allocaArray0

-- | Adjust the size of an array.
reallocArray :: (Storable a) => Ptr a -> Int -> IO (Ptr a)
reallocArray = reallocArray

-- | Adjust the size of an array including an extra position for the end marker.
reallocArray0 :: (Storable a) => Ptr a -> Int -> IO (Ptr a)
reallocArray0 = reallocArray0

-- | Convert an array of given length into a Haskell list.
peekArray :: (Storable a) => Int -> Ptr a -> IO [a]
peekArray = peekArray

-- | Convert an array terminated by the given end marker into a Haskell list.
peekArray0 :: (Storable a, Eq a) => a -> Ptr a -> IO [a]
peekArray0 = peekArray0

-- | Write the list elements consecutive into memory
pokeArray :: (Storable a) => Ptr a -> [a] -> IO ()
pokeArray = pokeArray

-- | Write the list elements consecutive into memory and terminate them with the given marker element
pokeArray0 :: (Storable a) => a -> Ptr a -> [a] -> IO ()
pokeArray0 = pokeArray0

-- | Write a list of storable elements into a newly allocated, consecutive sequence of storable values (like
-- 'Foreign.Marshal.Utils.new', but for multiple elements).
newArray :: Storable a => [a] -> IO (Ptr a)
newArray = newArray

-- | Write a list of storable elements into a newly allocated, consecutive sequence of storable values, where
-- the end is fixed by the given end marker
newArray0 :: Storable a => a -> [a] -> IO (Ptr a)
newArray0 = newArray0

-- | Temporarily store a list of storable values in memory (like 'Foreign.Marshal.Utils.with', but for
-- multiple elements).
withArray :: Storable a => [a] -> (Ptr a -> IO b) -> IO b
withArray = withArray

-- | Like 'withArray', but a terminator indicates where the array ends
withArray0 :: Storable a => a -> [a] -> (Ptr a -> IO b) -> IO b
withArray0 = withArray0

-- | Like 'withArray', but the action gets the number of values as an additional parameter
withArrayLen :: Storable a => [a] -> (Int -> Ptr a -> IO b) -> IO b
withArrayLen = withArrayLen

-- | Like 'withArrayLen', but a terminator indicates where the array ends
withArrayLen0 :: Storable a => a -> [a] -> (Int -> Ptr a -> IO b) -> IO b
withArrayLen0 = withArrayLen0

-- | Copy the given number of elements from the second array (source) into the first array (destination); the
-- copied areas may /not/ overlap
copyArray :: Storable a => Ptr a -> Ptr a -> Int -> IO ()
copyArray = copyArray

-- | Copy the given number of elements from the second array (source) into the first array (destination); the
-- copied areas /may/ overlap
moveArray :: Storable a => Ptr a -> Ptr a -> Int -> IO ()
moveArray = moveArray

-- | Return the number of elements in an array, excluding the terminator
lengthArray0 :: (Storable a, Eq a) => a -> Ptr a -> IO Int
lengthArray0 = lengthArray0

-- | Advance a pointer into an array by the given number of elements
advancePtr :: Storable a => Ptr a -> Int -> Ptr a
advancePtr = advancePtr
