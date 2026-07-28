-- |
-- Module: Foreign.Marshal.Alloc
--
-- The module @Foreign.Marshal.Alloc@ provides operations to allocate and deallocate blocks of raw mem-
-- ory (i.e., unstructured chunks of memory outside of the area maintained by the Haskell storage manager).
-- These memory blocks are commonly used to pass compound data structures to foreign functions or to pro-
-- vide space in which compound result values are obtained from foreign functions.
--
-- If any of the allocation functions fails, a value of 'nullPtr' is produced. If 'free' or 'reallocBytes' is
-- applied to a memory area that has been allocated with 'alloca' or 'allocaBytes', the behaviour is undefined.
-- Any further access to memory areas allocated with 'alloca' or 'allocaBytes', after the computation that
-- was passed to the allocation function has terminated, leads to undefined behaviour. Any further access to
-- the memory area referenced by a pointer passed to 'realloc', 'reallocBytes', or 'free' entails undefined
-- behaviour.
--
-- All storage allocated by functions that allocate based on a /size in bytes/ must be sufficiently aligned for any
-- of the basic foreign types that fits into the newly allocated storage. All storage allocated by functions that
-- allocate based on a specific type must be sufficiently aligned for that type. Array allocation routines need to
-- obey the same alignment constraints for each array element.
module Foreign.Marshal.Alloc
  ( -- * Memory allocation
    -- ** Local allocation
    alloca,
    allocaBytes,
    -- ** Dynamic allocation
    malloc,
    mallocBytes,
    realloc,
    reallocBytes,
    free,
    finalizerFree,
  )
where

import Data.Int
import Foreign.ForeignPtr
import Foreign.Ptr
import Foreign.Storable
import System.IO

-- | @alloca f@ executes the computation @f@, passing as argument a pointer to a temporarily allocated block
-- of memory sufficient to hold values of type @a@.
--
-- The memory is freed when @f@ terminates (either normally or via an exception), so the pointer passed to
-- @f@ must /not/ be used after this.
alloca :: (Storable a) => (Ptr a -> IO b) -> IO b
alloca = alloca

-- | @allocaBytes n f@ executes the computation @f@, passing as argument a pointer to a temporarily allocated
-- block of memory of @n@ bytes. The block of memory is sufficiently aligned for any of the basic
-- foreign types that fits into a memory block of the allocated size.
--
-- The memory is freed when @f@ terminates (either normally or via an exception), so the pointer passed to
-- @f@ must /not/ be used after this.
allocaBytes :: Int -> (Ptr a -> IO b) -> IO b
allocaBytes = allocaBytes

-- | Allocate a block of memory that is sufficient to hold values of type @a@. The size of the area allocated is
-- determined by the 'sizeOf' method from the instance of 'Storable' for the appropriate type.
--
-- The memory may be deallocated using 'free' or 'finalizerFree' when no longer required.
malloc :: (Storable a) => IO (Ptr a)
malloc = malloc

-- | Allocate a block of memory of the given number of bytes. The block of memory is sufficiently aligned
-- for any of the basic foreign types that fits into a memory block of the allocated size.
--
-- The memory may be deallocated using 'free' or 'finalizerFree' when no longer required.
mallocBytes :: Int -> IO (Ptr a)
mallocBytes = mallocBytes

-- | Resize a memory area that was allocated with 'malloc' or 'mallocBytes' to the size needed to store
-- values of type @b@. The returned pointer may refer to an entirely different memory area, but will be
-- suitably aligned to hold values of type @b@. The contents of the referenced memory area will be the same
-- as of the original pointer up to the minimum of the original size and the size of values of type @b@.
--
-- If the argument to 'realloc' is 'nullPtr', 'realloc' behaves like 'malloc'.
realloc :: (Storable b) => Ptr a -> IO (Ptr b)
realloc = realloc

-- | Resize a memory area that was allocated with 'malloc' or 'mallocBytes' to the given size. The returned
-- pointer may refer to an entirely different memory area, but will be sufficiently aligned for any of the
-- basic foreign types that fits into a memory block of the given size. The contents of the referenced
-- memory area will be the same as of the original pointer up to the minimum of the original size and the
-- given size.
--
-- If the pointer argument to 'reallocBytes' is 'nullPtr', 'reallocBytes' behaves like 'malloc'. If the
-- requested size is @0@, 'reallocBytes' behaves like 'free'.
reallocBytes :: Ptr a -> Int -> IO (Ptr a)
reallocBytes = reallocBytes

-- | Free a block of memory that was allocated with 'malloc', 'mallocBytes', 'realloc', 'reallocBytes',
-- 'Foreign.Marshal.Utils.new' or any of the @newX@ functions in @Foreign.Marshal.Array@ or
-- @Foreign.C.String@.
free :: Ptr a -> IO ()
free = free

-- | A pointer to a foreign function equivalent to 'free', which may be used as a finalizer (cf
-- 'Foreign.ForeignPtr.ForeignPtr') for storage allocated with 'malloc', 'mallocBytes', 'realloc'
-- or 'reallocBytes'.
finalizerFree :: FinalizerPtr a
finalizerFree = finalizerFree