-- |
-- Module: Numeric
module Numeric
  ( -- * Showing
    showSigned,
    showIntAtBase,
    showInt,
    showHex,
    showOct,
    showEFloat,
    showFFloat,
    showGFloat,
    showFloat,
    floatToDigits,

    -- * Reading

    -- | NB: @readInt@ is the ’dual’ of @showIntAtBase@, and @readDec@ is the ‘dual’ of @showInt@. The inconsistent
    -- naming is a historical accident.
    readSigned,
    readInt,
    readDec,
    readOct,
    readHex,
    readFloat,
    lexDigits,

    -- * Miscellaneous
    fromRat,
  )
where

import Prelude

-- | Converts a possibly-negative @Real@ value to a string
showSigned ::
  (Real a) =>
  -- | a function that can show unsigned values
  (a -> ShowS) ->
  -- | the precedence of the enclosing context
  Int ->
  -- | the value to show
  a ->
  ShowS
showSigned = showSigned

-- | Shows a non-negative @Integral@ number using the base specified by the first argument, and the character
-- representation specified by the second.
showIntAtBase :: (Integral a) => a -> (Int -> Char) -> a -> ShowS
showIntAtBase = showIntAtBase

-- | Show non-negative @Integral@ numbers in base 10.
showInt :: (Integral a) => a -> ShowS
showInt = showInt

-- | Show non-negative @Integral@ numbers in base 16.
showHex :: (Integral a) => a -> ShowS
showHex = showHex

-- | Show non-negative @Integral@ numbers in base 8.
showOct :: (Integral a) => a -> ShowS
showOct = showOct

-- | Show a signed @RealFloat@ value using scientific (exponential) notation (e.g. @2.45e2@, @1.5e-3@).
--
-- In the call @showEFloat digs val@, if @digs@ is @Nothing@, the value is shown to full precision; if @digs@
-- is @Just d@, then at most @d@ digits after the decimal point are shown.
showEFloat :: (RealFloat a) => Maybe Int -> a -> ShowS
showEFloat = showEFloat

-- | Show a signed @RealFloat@ value using standard decimal notation (e.g. @245000@, @0.0015@).
--
-- In the call @showFFloat digs val@, if @digs@ is @Nothing@, the value is shown to full precision; if @digs@
-- is @Just d@, then at most @d@ digits after the decimal point are shown.
showFFloat :: (RealFloat a) => Maybe Int -> a -> ShowS
showFFloat = showFFloat

-- | Show a signed @RealFloat@ value using standard decimal notation for arguments whose absolute value
-- lies between @0.1@ and @9,999,999@, and scientific notation otherwise.
--
-- In the call @showGFloat digs val@, if @digs@ is @Nothing@, the value is shown to full precision; if @digs@
-- is @Just d@, then at most @d@ digits after the decimal point are shown.
showGFloat :: (RealFloat a) => Maybe Int -> a -> ShowS
showGFloat = showGFloat

-- | Show a signed RealFloat value to full precision using standard decimal notation for arguments whose
-- absolute value lies between @0.1@ and @9,999,999@, and scientific notation otherwise.
showFloat :: (RealFloat a) => a -> ShowS
showFloat = showFloat

-- | @floatToDigits@ takes a base and a non-negative @RealFloat@ number, and returns a list of digits and
-- an exponent. In particular, if @x>=0@, and
--
-- @
-- floatToDigits base x = ([d1,d2,...,dn], e)
-- @
--
-- then
--
-- 1. @n >= 1@
-- 2. @x = 0.d1d2...dn * (base**e)@
-- 3. @0 <= di <= base-1@
floatToDigits :: (RealFloat a) => Integer -> a -> ([Int], Int)
floatToDigits = floatToDigits

-- | Reads a signed @Real@ value, given a reader for an unsigned value
readSigned :: (Real a) => ReadS a -> ReadS a
readSigned = readSigned

-- | Reads an unsigned @Integral@ value in an arbitrary base.
readInt ::
  (Num a) =>
  -- | the base
  a ->
  -- | a predicate distinguishing valid digits in this base
  (Char -> Bool) ->
  -- | a function converting a valid digit character to an Int
  (Char -> Int) ->
  ReadS a
readInt = readInt

-- | Read an unsigned number in decimal notation.
readDec :: Num a => ReadS a
readDec = readDec

-- | Read an unsigned number in octal notation.
readOct :: Num a => ReadS a
readOct = readOct

-- | Read an unsigned number in hexadecimal notation. Both upper or lower case letters are allowed
readHex :: Num a => ReadS a
readHex = readHex

-- | Reads an unsigned @RealFrac@ value, expressed in decimal scientific notation
readFloat :: RealFrac a => ReadS a
readFloat = readFloat

-- | Reads a non-empty string of decimal digits.
lexDigits :: ReadS String
lexDigits = lexDigits

-- | Converts a @Rational@ value into any type in class @RealFloat@.
fromRat :: RealFloat a => Rational -> a
fromRat = fromRat