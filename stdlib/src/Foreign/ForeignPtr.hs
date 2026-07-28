-- |
-- Module: Foreign.ForeignPtr
module Foreign.ForeignPtr
  ( -- * Finalised data pointers
    ForeignPtr,
    FinalizerPtr,
    FinalizerEnvPtr,

    -- ** Basic operations
    newForeignPtr,
    newForeignPtr_,
    addForeignPtrFinalizer,
    newForeignPtrEnv,
    addForeignPtrFinalizerEnv,
    withForeignPtr,
    finalizeForeignPtr,

    -- ** Low-level operations
    unsafeForeignPtrToPtr,
    touchForeignPtr,
    castForeignPtr,

    -- ** Allocating managed memory
    mallocForeignPtr,
    mallocForeignPtrBytes,
    mallocForeignPtrArray,
    mallocForeignPtrArray0,
  )
where

import Data.Eq
import Data.Int
import Data.Ord
import Foreign.Ptr
import Foreign.Storable
import System.IO
import Text.Show

-- | The type 'ForeignPtr' represents references to objects that are maintained in a foreign language, i.e.,
-- that are not part of the data structures usually managed by the Haskell storage manager. The essential
-- difference between 'ForeignPtr's and vanilla memory references of type @Ptr a@ is that the former may
-- be associated with finalizers. A finalizer is a routine that is invoked when the Haskell storage manager
-- detects that - within the Haskell heap and stack - there are no more references left that are pointing to
-- the 'ForeignPtr'. Typically, the finalizer will, then, invoke routines in the foreign language that free
-- the resources bound by the foreign object.
--
-- The 'ForeignPtr' is parameterised in the same way as 'Ptr'. The type argument of 'ForeignPtr' should
-- normally be an instance of class 'Storable'.
data ForeignPtr a = AbstractForeignPtr

instance Eq (ForeignPtr a)

instance Ord (ForeignPtr a)

instance Show (ForeignPtr a)

-- | A finalizer is represented as a pointer to a foreign function that, at finalisation time, gets as an argument
-- a plain pointer variant of the foreign pointer that the finalizer is associated with.
type FinalizerPtr a = FunPtr (Ptr a -> IO ())

type FinalizerEnvPtr env a = FunPtr (Ptr env -> Ptr a -> IO ())

-- | Turns a plain memory reference into a foreign pointer, and associates a finalizer with the reference. The
-- finalizer will be executed after the last reference to the foreign object is dropped. There is no guarantee
-- of promptness, however the finalizer will be executed before the program exits.
newForeignPtr :: FinalizerPtr a -> Ptr a -> IO (ForeignPtr a)
newForeignPtr = newForeignPtr

-- | Turns a plain memory reference into a foreign pointer that may be associated with finalizers by using
-- 'addForeignPtrFinalizer'.
newForeignPtr_ :: Ptr a -> IO (ForeignPtr a)
newForeignPtr_ = newForeignPtr_

-- | This function adds a finalizer to the given foreign object. The finalizer will run /before/ all other finalizers
-- for the same object which have already been registered.
addForeignPtrFinalizer :: FinalizerPtr a -> ForeignPtr a -> IO ()
addForeignPtrFinalizer = addForeignPtrFinalizer

-- | This variant of 'newForeignPtr' adds a finalizer that expects an environment in addition to the finalized pointer.
-- The environment that will be passed to the finalizer is fixed by the second argument to 'newForeignPtrEnv'.
newForeignPtrEnv :: FinalizerEnvPtr env a -> Ptr env -> Ptr a -> IO (ForeignPtr a)
newForeignPtrEnv = newForeignPtrEnv

-- | Like 'addForeignPtrFinalizerEnv' but allows the finalizer to be passed an additional environment
-- parameter to be passed to the finalizer. The environment passed to the finalizer is fixed by the second
-- argument to 'addForeignPtrFinalizerEnv'.
addForeignPtrFinalizerEnv :: FinalizerEnvPtr env a -> Ptr env -> ForeignPtr a -> IO ()
addForeignPtrFinalizerEnv = addForeignPtrFinalizerEnv

-- | This is a way to look at the pointer living inside a foreign object. This function takes a function
-- which is applied to that pointer. The resulting 'IO' action is then executed. The foreign object is kept
-- alive at least during the whole action, even if it is not used directly inside. Note that it is not safe
-- to return the pointer from the action and use it after the action completes. All uses of the pointer
-- should be inside the 'withForeignPtr' bracket. The reason for this unsafeness is the same as for
-- 'unsafeForeignPtrToPtr' below: the finalizer may run earlier than expected, because the compiler
-- can only track usage of the 'ForeignPtr' object, not a 'Ptr' object made from it.
--
-- This function is normally used for marshalling data to or from the object pointed to by the
-- 'ForeignPtr', using the operations from the 'Storable' class.
withForeignPtr :: ForeignPtr a -> (Ptr a -> IO b) -> IO b
withForeignPtr = withForeignPtr

-- | Causes the finalizers associated with a foreign pointer to be run immediately.
finalizeForeignPtr :: ForeignPtr a -> IO ()
finalizeForeignPtr = finalizeForeignPtr

-- | This function extracts the pointer component of a foreign pointer. This is a potentially dangerous
-- operations, as if the argument to 'unsafeForeignPtrToPtr' is the last usage occurrence of the given
-- foreign pointer, then its finalizer(s) will be run, which potentially invalidates the plain pointer just
-- obtained. Hence, 'touchForeignPtr' must be used wherever it has to be guaranteed that the pointer
-- lives on - i.e., has another usage occurrence.
--
-- To avoid subtle coding errors, hand written marshalling code should preferably use
-- 'Foreign.ForeignPtr.withForeignPtr' rather than combinations of 'unsafeForeignPtrToPtr'
-- and 'touchForeignPtr'. However, the latter routines are occasionally preferred in tool generated
-- marshalling code.
unsafeForeignPtrToPtr :: ForeignPtr a -> Ptr a
unsafeForeignPtrToPtr = unsafeForeignPtrToPtr

-- | This function ensures that the foreign object in question is alive at the given place in the sequence of IO
-- actions. In particular 'withForeignPtr' does a 'touchForeignPtr' after it executes the user action.
--
-- Note that this function should not be used to express dependencies between finalizers on 'ForeignPtr's.
-- For example, if the finalizer for a @ForeignPtr F1@ calls 'touchForeignPtr' on a second @ForeignPtr
-- F2@, then the only guarantee is that the finalizer for @F2@ is never started before the finalizer for @F1@. They
-- might be started together if for example both @F1@ and @F2@ are otherwise unreachable.
--
-- In general, it is not recommended to use finalizers on separate objects with ordering constraints between
-- them. To express the ordering robustly requires explicit synchronisation between finalizers.
touchForeignPtr :: ForeignPtr a -> IO ()
touchForeignPtr = touchForeignPtr

-- | This function casts a 'ForeignPtr' parameterised by one type into another type.
castForeignPtr :: ForeignPtr a -> ForeignPtr b
castForeignPtr = castForeignPtr

-- | Allocate some memory and return a 'ForeignPtr' to it. The memory will be released automatically
-- when the 'ForeignPtr' is discarded.
--
-- 'mallocForeignPtr' is equivalent to
--
-- @
-- do { p <- malloc; newForeignPtr finalizerFree p }
-- @
--
-- although it may be implemented differently internally: you may not assume that the memory returned
-- by 'mallocForeignPtr' has been allocated with 'Foreign.Marshal.Alloc.malloc'.
mallocForeignPtr :: (Storable a) => IO (ForeignPtr a)
mallocForeignPtr = mallocForeignPtr

-- | This function is similar to 'mallocForeignPtr', except that the size of the memory required is given
-- explicitly as a number of bytes.
mallocForeignPtrBytes :: Int -> IO (ForeignPtr a)
mallocForeignPtrBytes = mallocForeignPtrBytes

-- | This function is similar to 'Foreign.Marshal.Array.mallocArray', but yields a memory area that
-- has a finalizer attached that releases the memory area. As with 'mallocForeignPtr', it is not guaranteed
-- that the block of memory was allocated by 'Foreign.Marshal.Alloc.malloc'.
mallocForeignPtrArray :: (Storable a) => Int -> IO (ForeignPtr a)
mallocForeignPtrArray = mallocForeignPtrArray

-- | This function is similar to 'Foreign.Marshal.Array.mallocArray0', but yields a memory area
-- that has a finalizer attached that releases the memory area. As with 'mallocForeignPtr', it is not
-- guaranteed that the block of memory was allocated by 'Foreign.Marshal.Alloc.malloc'.
mallocForeignPtrArray0 :: (Storable a) => Int -> IO (ForeignPtr a)
mallocForeignPtrArray0 = mallocForeignPtrArray0