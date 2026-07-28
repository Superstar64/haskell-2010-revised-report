-- |
-- Module: Foreign.Storable
module Foreign.Storable
  ( Storable
      ( sizeOf,
        alignment,
        peekElemOff,
        pokeElemOff,
        peekByteOff,
        pokeByteOff,
        peek,
        poke
      ),
  )
where

import Data.Bool
import Data.Int
import Data.Word
import Foreign.Ptr
import Foreign.StablePtr
import Prim
import System.IO

-- | The member functions of this class facilitate writing values of primitive types to raw memory (which
-- may have been allocated with the above mentioned routines) and reading values from blocks of raw
-- memory. The class, furthermore, includes support for computing the storage requirements and alignment
-- restrictions of storable types.
--
-- Memory addresses are represented as values of type @Ptr a@, for some a which is an instance of class
-- 'Storable'. The type argument to 'Ptr' helps provide some valuable type safety in FFI code (you can’t
-- mix pointers of different types without an explicit cast), while helping the Haskell type system figure
-- out which marshalling method is needed for a given pointer.
--
-- All marshalling between Haskell and a foreign language ultimately boils down to translating Haskell
-- data structures into the binary representation of a corresponding data structure of the foreign language
-- and vice versa. To code this marshalling in Haskell, it is necessary to manipulate primitive data
-- types stored in unstructured memory blocks. The class 'Storable' facilitates this manipulation on all
-- types for which it is instantiated, which are the standard basic types of Haskell, the fixed size Int
-- types ('Int8', 'Int16', 'Int32', 'Int64'), the fixed size Word types ('Word8', 'Word16', 'Word32', 'Word64'),
-- 'StablePtr', all types from @Foreign.C.Types@, as well as 'Ptr'.
--
-- Minimal complete definition: 'sizeOf', 'alignment', one of 'peek', 'peekElemOff' and 'peekByteOff',
-- and one of 'poke', 'pokeElemOff' and 'pokeByteOff'.
class Storable a where
  -- | Computes the storage requirements (in bytes) of the argument. The value of the argument is not
  -- used.
  sizeOf :: a -> Int

  -- | Computes the alignment constraint of the argument. An alignment constraint @x@ is fulfilled by any
  -- address divisible by @x@. The value of the argument is not used.
  alignment :: a -> Int

  -- | Read a value from a memory area regarded as an array of values of the same kind. The first
  -- argument specifies the start address of the array and the second the index into the array (the first
  -- element of the array has index 0). The following equality holds,
  --
  -- @
  -- peekElemOff addr idx = IOExts.fixIO $ \\result ->
  --   peek (addr ‘plusPtr‘ (idx * sizeOf result))
  -- @
  --
  -- Note that this is only a specification, not necessarily the concrete implementation of the function.
  peekElemOff :: Ptr a -> Int -> IO a

  -- | Write a value to a memory area regarded as an array of values of the same kind. The following
  -- equality holds:
  --
  -- @
  -- pokeElemOff addr idx x =
  --   poke (addr ‘plusPtr‘ (idx * sizeOf x)) x
  -- @
  pokeElemOff :: Ptr a -> Int -> a -> IO ()

  -- | Read a value from a memory location given by a base address and offset. The following equality
  -- holds:
  --
  -- @
  -- peekByteOff addr off = peek (addr ‘plusPtr‘ off)
  -- @
  peekByteOff :: Ptr b -> Int -> IO a

  -- | Write a value to a memory location given by a base address and offset. The following equality
  -- holds:
  --
  -- @
  -- pokeByteOff addr off x = poke (addr ‘plusPtr‘ off) x
  -- @
  pokeByteOff :: Ptr b -> Int -> a -> IO ()

  -- | Read a value from the given memory location.
  --
  -- Note that the peek and poke functions might require properly aligned addresses to function correctly.
  -- This is architecture dependent; thus, portable code should ensure that when peeking or
  -- poking values of some type @a@, the alignment constraint for @a@, as given by the function 'alignment'
  -- is fulfilled.
  peek :: Ptr a -> IO a

  -- | Write the given value to the given memory location. Alignment restrictions might apply; see
  -- 'peek'.
  poke :: Ptr a -> a -> IO ()

instance Storable (StablePtr a)

instance Storable (Ptr a)

instance Storable (FunPtr a)

instance Storable Char

instance Storable Bool

instance Storable Double

instance Storable Float

instance Storable IntPtr

instance Storable WordPtr

instance Storable Word

instance Storable Word8

instance Storable Word16

instance Storable Word32

instance Storable Word64

instance Storable Int

instance Storable Int8

instance Storable Int16

instance Storable Int32

instance Storable Int64