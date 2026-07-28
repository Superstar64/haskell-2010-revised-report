-- |
-- Module : Data.Word
-- Description: Unsigned integral types
--
-- This module provides unsigned integer types of unspecified width ('Word') and fixed widths ('Word8', 'Word16', 'Word32' and 'Word64').
-- All arithmetic is performed modulo 2^n, where n is the number of bits in the type.
--
-- For coercing between any two integer types, use 'fromIntegral'. Coercing word types to and from integer types preserves representation, not sign.
--
-- The rules that hold for 'Enum' instances over a bounded type such as 'Int' (see the section of the Haskell language report dealing with arithmetic sequences) also hold for the 'Enum' instances over the various 'Word' types defined here.
--
-- Right and left shifts by amounts greater than or equal to the width of the type result in a zero result. This is contrary to the behaviour in C, which is undefined; a common interpretation is to truncate the shift count to the width of the type, for example 1 << 32 == 1 in some C implementations.
module Data.Word (Word, Word8, Word16, Word32, Word64) where

-- | A Word is an unsigned integral type, with the same size as Int.
data Word = AbstractWord

-- | 8-bit unsigned integer type
data Word8 = AbstractWord8

-- | 16-bit unsigned integer type
data Word16 = AbstractWord16

-- | 32-bit unsigned integer type
data Word32 = AbstractWord32

-- | 64-bit unsigned integer type
data Word64 = AbstractWord64