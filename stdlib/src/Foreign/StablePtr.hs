module Foreign.StablePtr
  ( -- * Stable references to Haskell values
    StablePtr,
    newStablePtr,
    deRefStablePtr,
    freeStablePtr,
    castStablePtrToPtr,
    castPtrToStablePtr,
    -- ** The C-Side interface

    -- | The following definition is available to C programs inter-operating with Haskell code when including the
    -- header @HsFFI.h@.
    --
    -- @
    -- typedef void *HsStablePtr;
    -- @
    --
    -- Note that no assumptions may be made about the values representing stable pointers. In fact, they need not
    -- even be valid memory addresses. The only guarantee provided is that if they are passed back to Haskell land,
    -- the function 'deRefStablePtr' will be able to reconstruct the Haskell value referred to by the stable pointer.
  )
where

import Data.Eq
import Foreign.Ptr
import System.IO

-- | A /stable pointer/ is a reference to a Haskell expression that is guaranteed not to be affected by garbage
-- collection, i.e., it will neither be deallocated nor will the value of the stable pointer itself change during
-- garbage collection (ordinary references may be relocated during garbage collection). Consequently,
-- stable pointers can be passed to foreign code, which can treat it as an opaque reference to a Haskell
-- value.
--
-- A value of type @StablePtr a@ is a stable pointer to a Haskell expression of type @a@.
data StablePtr a = AbstractStablePtr

instance Eq (StablePtr a)

-- | Create a stable pointer referring to the given Haskell value.
newStablePtr :: a -> IO (StablePtr a)
newStablePtr = newStablePtr

-- | Obtain the Haskell value referenced by a stable pointer, i.e., the same value that was passed to the
-- corresponding call to 'newStablePtr'. If the argument to 'deRefStablePtr' has already been freed
-- using 'freeStablePtr', the behaviour of 'deRefStablePtr' is undefined.
deRefStablePtr :: StablePtr a -> IO a
deRefStablePtr = deRefStablePtr

-- | Dissolve the association between the stable pointer and the Haskell value. Afterwards, if the stable
-- pointer is passed to 'deRefStablePtr' or 'freeStablePtr', the behaviour is undefined. However,
-- the stable pointer may still be passed to 'castStablePtrToPtr', but the @Foreign.Ptr.Ptr
-- ()@ value returned by 'castStablePtrToPtr', in this case, is undefined (in particular, it may be
-- 'Foreign.Ptr.nullPtr'). Nevertheless, the call to 'castStablePtrToPtr' is guaranteed not to diverge.
freeStablePtr :: StablePtr a -> IO ()
freeStablePtr = freeStablePtr

-- | Coerce a stable pointer to an address. No guarantees are made about the resulting value, except that the
-- original stable pointer can be recovered by 'castPtrToStablePtr'. In particular, the address may not
-- refer to an accessible memory location and any attempt to pass it to the member functions of the class
-- 'Foreign.Storable.Storable' leads to undefined behaviour.
castStablePtrToPtr :: StablePtr a -> Ptr ()
castStablePtrToPtr = castStablePtrToPtr

-- | The inverse of 'castStablePtrToPtr', i.e., we have the identity
--
-- @
-- sp == castPtrToStablePtr (castStablePtrToPtr sp)
-- @
--
-- for any stable pointer @sp@ on which 'freeStablePtr' has not been executed yet. Moreover,
-- 'castPtrToStablePtr' may only be applied to pointers that have been produced by
-- 'castStablePtrToPtr'.
castPtrToStablePtr :: Ptr () -> StablePtr a
castPtrToStablePtr = castPtrToStablePtr