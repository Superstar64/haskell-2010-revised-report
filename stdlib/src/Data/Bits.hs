-- |
-- Module: Data.Bits
--
-- This module defines bitwise operations for signed and unsigned integers.
module Data.Bits
  ( Bits
      ( (.&.),
        (.|.),
        xor,
        complement,
        shift,
        rotate,
        bit,
        setBit,
        clearBit,
        complementBit,
        testBit,
        bitSize,
        isSigned,
        shiftL,
        shiftR,
        rotateL,
        rotateR
      ),
  )
where

import Data.Int
import Data.Word
import Prelude

-- | The Bits class defines bitwise operations over integral types.
--
--  * Bits are numbered from 0 with bit 0 being the least significant bit.
--
-- Minimal complete definition: .&., .|., xor, complement, (shift or (shiftL and shiftR)), (rotate or (rotateL and rotateR)), bitSize and isSigned.
class (Num a) => Bits a where
  -- | Bitwise "and"
  (.&.) :: a -> a -> a

  -- | Bitwise "or"
  (.|.) :: a -> a -> a

  -- | Bitwise "xor"
  xor :: a -> a -> a

  -- | Reverse all the bits in the argument
  complement :: a -> a

  -- | @shift x i@ shifts @x@ left by @i@ bits if @i@ is positive, or right by @-i@ bits otherwise. Right shifts perform sign extension on signed number types; i.e. they fill the top bits with 1 if the @x@ is negative and with 0 otherwise.
  --
  -- An instance can define either this unified @shift@ or @shiftL@ and @shiftR@, depending on which is more convenient for the type in question.
  shift :: a -> Int -> a

  -- | @rotate x i@ rotates @x@ left by @i@ bits if @i@ is positive, or right by @-i@ bits otherwise.
  --
  -- For unbounded types like @Integer@, @rotate@ is equivalent to @shift@.
  --
  -- An instance can define either this unified @rotate@ or @rotateL@ and @rotateR@, depending on which is more convenient for the type in question.
  rotate :: a -> Int -> a

  -- | @bit i@ is a value with the @i@th bit set and all other bits clear
  bit :: Int -> a

  -- | @x ‘setBit‘ i@ is the same as @x .|. bit i@
  setBit :: a -> Int -> a

  -- | @x ‘clearBit‘ i@ is the same as @x .&. complement (bit i)@
  clearBit :: a -> Int -> a

  -- | @x ‘complementBit‘ i@ is the same as @x ‘xor‘ bit i@
  complementBit :: a -> Int -> a

  -- | Return @True@ if the nth bit of the argument is 1
  testBit :: a -> Int -> Bool

  -- | Return the number of bits in the type of the argument. The actual value of the argument is ignored. The function @bitSize@ is undefined for types that do not have a fixed bitsize, like @Integer@.
  bitSize :: a -> Int

  -- | Return @True@ if the argument is a signed type. The actual value of the argument is ignored
  isSigned :: a -> Bool

  -- | Shift the argument left by the specified number of bits (which must be non-negative).
  --
  -- An instance can define either this and @shiftR@ or the unified @shift@, depending on which is more convenient for the type in question.
  shiftL :: a -> Int -> a

  -- | Shift the first argument right by the specified number of bits (which must be non-negative). Right shifts perform sign extension on signed number types; i.e. they fill the top bits with 1 if the @x@ is negative and with 0 otherwise.
  --
  -- An instance can define either this and @shiftL@ or the unified @shift@, depending on which is more convenient for the type in question.
  shiftR :: a -> Int -> a

  -- | Rotate the argument left by the specified number of bits (which must be non-negative).
  --
  -- An instance can define either this and @rotateR@ or the unified @rotate@, depending on which is more convenient for the type in question.
  rotateL :: a -> Int -> a

  -- | Rotate the argument right by the specified number of bits (which must be non-negative).
  --
  -- An instance can define either this and @rotateL@ or the unified @rotate@, depending on which is more convenient for the type in question.
  rotateR :: a -> Int -> a

instance Bits Int

instance Bits Integer

instance Bits Int8

instance Bits Int16

instance Bits Int32

instance Bits Int64

instance Bits Word

instance Bits Word8

instance Bits Word16

instance Bits Word32

instance Bits Word64