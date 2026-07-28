-- |
-- Module: Foreign.Ptr
--
-- The module @Foreign.Ptr@ provides typed pointers to foreign entities. We distinguish two kinds of pointers:
-- pointers to data and pointers to functions. It is understood that these two kinds of pointers may be represented
-- differently as they may be references to data and text segments, respectively.
module Foreign.Ptr
  ( -- * Data pointers
    Ptr,
    nullPtr,
    castPtr,
    plusPtr,
    alignPtr,
    minusPtr,

    -- * Function pointers
    FunPtr,
    nullFunPtr,
    castFunPtr,
    castFunPtrToPtr,
    castPtrToFunPtr,
    freeHaskellFunPtr,

    -- * Integral types with lossless conversion to and from pointers
    IntPtr,
    ptrToIntPtr,
    intPtrToPtr,
    WordPtr,
    ptrToWordPtr,
    wordPtrToPtr,
  )
where

import Data.Enum
import Data.Eq
import Data.Bits
import Data.Int
import Data.Ord
import System.IO
import Text.Show
import Text.Read
import NumHierarchy

-- | A value of type @Ptr a@ represents a pointer to an object, or an array of objects, which may be marshalled
-- to or from Haskell values of type @a@.
--
-- The type @a@ will often be an instance of class 'Foreign.Storable.Storable' which provides the
-- marshalling operations. However this is not essential, and you can provide your own operations to
-- access the pointer. For example you might write small foreign functions to get or set the fields of a C
-- @struct@.
data Ptr a = AbstractPtr

instance Eq (Ptr a)

instance Ord (Ptr a)

instance Show (Ptr a)

-- | The constant 'nullPtr' contains a distinguished value of 'Ptr' that is not associated with a valid memory
-- location
nullPtr :: Ptr a
nullPtr = nullPtr

-- | The 'castPtr' function casts a pointer from one type to another.
castPtr :: Ptr a -> Ptr b
castPtr = castPtr

-- | Advances the given address by the given offset in bytes.
plusPtr :: Ptr a -> Int -> Ptr b
plusPtr = plusPtr

-- | Given an arbitrary address and an alignment constraint, 'alignPtr' yields the next higher address that
-- fulfills the alignment constraint. An alignment constraint @x@ is fulfilled by any address divisible by @x@.
-- This operation is idempotent.
alignPtr :: Ptr a -> Int -> Ptr a
alignPtr = alignPtr

-- | Computes the offset required to get from the second to the first argument. We have
--
-- @
-- p2 == p1 ‘plusPtr‘ (p2 ‘minusPtr‘ p1)
-- @
minusPtr :: Ptr a -> Ptr b -> Int
minusPtr = minusPtr

-- | A value of type @FunPtr a@ is a pointer to a function callable from foreign code. The type @a@ will
-- normally be a /foreign type/, a function type with zero or more arguments where
--
-- - the argument types are /marshallable foreign types/, i.e. 'Char', 'Int', 'Double', 'Float',
--   'Bool', 'Data.Int.Int8', 'Data.Int.Int16', 'Data.Int.Int32', 'Data.Int.Int64',
--   'Data.Word.Word8', 'Data.Word.Word16', 'Data.Word.Word32', 'Data.Word.Word64',
--   @Ptr a@, @FunPtr a@, @Foreign.StablePtr.StablePtr a@ or a renaming of any of these using @newtype@.
-- - the return type is either a marshallable foreign type or has the form @IO t@ where @t@ is a marshallable
--   foreign type or @()@.
--
-- A value of type @FunPtr a@ may be a pointer to a foreign function, either returned by another foreign
-- function or imported with a a static address import like
--
-- @
-- foreign import ccall "stdlib.h &free"
--   p_free :: FunPtr (Ptr a -> IO ())
-- @
--
-- or a pointer to a Haskell function created using a /wrapper/ stub declared to produce a 'FunPtr' of the
-- correct type. For example:
--
-- @
-- type Compare = Int -> Int -> Bool
-- foreign import ccall "wrapper"
--   mkCompare :: Compare -> IO (FunPtr Compare)
-- @
--
-- Calls to wrapper stubs like @mkCompare@ allocate storage, which should be released with
-- 'Foreign.Ptr.freeHaskellFunPtr' when no longer required.
--
-- To convert 'FunPtr' values to corresponding Haskell functions, one can define a dynamic stub for the
-- specific foreign type, e.g.
--
-- @
-- type IntFunction = CInt -> IO ()
-- foreign import ccall "dynamic"
--   mkFun :: FunPtr IntFunction -> IntFunction
-- @
data FunPtr a = AbstractFunPtr

instance Eq (FunPtr a)

instance Ord (FunPtr a)

instance Show (FunPtr a)

-- | The constant 'nullFunPtr' contains a distinguished value of 'FunPtr' that is not associated with a valid
-- memory location
nullFunPtr :: FunPtr a
nullFunPtr = nullFunPtr

-- | Casts a 'FunPtr' to a 'FunPtr' of a different type.
castFunPtr :: FunPtr a -> FunPtr b
castFunPtr = castFunPtr

-- | Casts a 'FunPtr' to a 'Ptr'.
--
-- /Note:/ this is valid only on architectures where data and function pointers range over the same set of
-- addresses, and should only be used for bindings to external libraries whose interface already relies on
-- this assumption.
castFunPtrToPtr :: FunPtr a -> Ptr b
castFunPtrToPtr = castFunPtrToPtr

-- | Casts a 'Ptr' to a 'FunPtr'.
--
-- /Note:/ this is valid only on architectures where data and function pointers range over the same set of
-- addresses, and should only be used for bindings to external libraries whose interface already relies on
-- this assumption.
castPtrToFunPtr :: Ptr a -> FunPtr b
castPtrToFunPtr = castPtrToFunPtr

-- | Release the storage associated with the given 'FunPtr', which must have been obtained from a wrapper
-- stub. This should be called whenever the return value from a foreign import wrapper function is no
-- longer required; otherwise, the storage it uses will leak.
freeHaskellFunPtr :: FunPtr a -> IO ()
freeHaskellFunPtr = freeHaskellFunPtr

-- | A signed integral type that can be losslessly converted to and from 'Ptr'. This type is also compatible
-- with the C99 type @intptr_t@, and can be marshalled to and from that type safely.
data IntPtr = AbstractIntPtr

instance Eq IntPtr

instance Ord IntPtr

instance Show IntPtr

instance Read IntPtr

instance Enum IntPtr

instance Bounded IntPtr

instance Num IntPtr

instance Real IntPtr

instance Integral IntPtr

instance Bits IntPtr

-- | casts a 'Ptr' to an 'IntPtr'
ptrToIntPtr :: Ptr a -> IntPtr
ptrToIntPtr = ptrToIntPtr

-- | casts an 'IntPtr' to a 'Ptr'
intPtrToPtr :: IntPtr -> Ptr a
intPtrToPtr = intPtrToPtr

-- | An unsigned integral type that can be losslessly converted to and from 'Ptr'. This type is also compatible
-- with the C99 type @uintptr_t@, and can be marshalled to and from that type safely.
data WordPtr = AbstractWordPtr

instance Eq WordPtr

instance Ord WordPtr

instance Show WordPtr

instance Read WordPtr

instance Enum WordPtr

instance Bounded WordPtr

instance Num WordPtr

instance Real WordPtr

instance Integral WordPtr

instance Bits WordPtr

-- | casts a 'Ptr' to a 'WordPtr'
ptrToWordPtr :: Ptr a -> WordPtr
ptrToWordPtr = ptrToWordPtr

-- | casts a 'WordPtr' to a 'Ptr'
wordPtrToPtr :: WordPtr -> Ptr a
wordPtrToPtr = wordPtrToPtr
