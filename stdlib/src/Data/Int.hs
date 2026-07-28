-- |
-- Module : Data.Int
-- Description: Signed integer types
--
-- This module provides signed integer types of unspecified width ('Int') and fixed widths ('Int8', 'Int16', 'Int32' and 'Int64').
-- All arithmetic is performed modulo 2^n, where n is the number of bits in the type.
--
-- For coercing between any two integer types, use 'fromIntegral'. Coercing word types (see 'Data.Word') to and from integer types preserves representation, not sign.
--
-- The rules that hold for 'Enum' instances over a bounded type such as 'Int' (see the section of the Haskell language report dealing with arithmetic sequences) also hold for the 'Enum' instances over the various Int types defined here.
--
-- Right and left shifts by amounts greater than or equal to the width of the type result in either zero or -1, depending on the sign of the value being shifted. This is contrary to the behaviour in C, which is undefined; a common interpretation is to truncate the shift count to the width of the type, for example 1 << 32 == 1 in some C implementations.
module Data.Int (Int, Int8, Int16, Int32, Int64) where

-- | A fixed-precision integer type with at least the range [-2^29 .. 2^29-1].
-- The exact range for a given implementation can be determined by using 'Prelude.minBound' and 'Prelude.maxBound' from the 'Prelude.Bounded' class.
data Int = AbstractInt

-- | 8-bit signed integer type
data Int8 = AbstractInt8

-- | 16-bit signed integer type
data Int16 = AbstractInt16

-- | 32-bit signed integer type
data Int32 = AbstractInt32

-- | 64-bit signed integer type
data Int64 = AbstractInt64