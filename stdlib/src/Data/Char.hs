-- |
-- Module: Data.Char
module Data.Char
  ( -- * Characters and strings
    Char,
    String,

    -- * Character classification

    -- | Unicode characters are divided into letters, numbers, marks, punctuation, symbols, separators (including
    -- spaces) and others (including control characters).
    isControl,
    isSpace,
    isLower,
    isUpper,
    isAlpha,
    isAlphaNum,
    isPrint,
    isDigit,
    isOctDigit,
    isHexDigit,
    isLetter,
    isMark,
    isNumber,
    isPunctuation,
    isSymbol,
    isSeparator,

    -- * Subranges
    isAscii,
    isLatin1,
    isAsciiUpper,
    isAsciiLower,

    -- * Unicode general categories
    GeneralCategory
      ( UppercaseLetter,
        LowercaseLetter,
        TitlecaseLetter,
        ModifierLetter,
        OtherLetter,
        NonSpacingMark,
        SpacingCombiningMark,
        EnclosingMark,
        DecimalNumber,
        LetterNumber,
        OtherNumber,
        ConnectorPunctuation,
        DashPunctuation,
        OpenPunctuation,
        ClosePunctuation,
        InitialQuote,
        FinalQuote,
        OtherPunctuation,
        MathSymbol,
        CurrencySymbol,
        ModifierSymbol,
        OtherSymbol,
        Space,
        LineSeparator,
        ParagraphSeparator,
        Control,
        Format,
        Surrogate,
        PrivateUse,
        NotAssigned
      ),
    generalCategory,

    -- * Case conversion
    toUpper,
    toLower,
    toTitle,

    -- * Single digit characters
    digitToInt,
    intToDigit,

    -- * Numeric representations
    ord,
    chr,

    -- * String representations
    showLitChar,
    lexLitChar,
    readLitChar,
  )
where

import Data.Bool
import Data.Enum
import Data.Eq
import Data.Int
import Data.Ix
import Data.Ord
import Data.String
import Prim (Char)
import Text.Read
import Text.Show

-- | Selects control characters, which are the non-printing characters of the Latin-1 subset of Unicode.
isControl :: Char -> Bool
isControl = isControl

-- | Returns @True@ for any Unicode space character, and the control characters @\\t@, @\\n@, @\\r@, @\\f@, @\\v@.
isSpace :: Char -> Bool
isSpace = isSpace

-- | Selects lower-case alphabetic Unicode characters (letters).
isLower :: Char -> Bool
isLower = isLower

-- | Selects upper-case or title-case alphabetic Unicode characters (letters). Title case is used by a small
-- number of letter ligatures like the single-character form of Lj.
isUpper :: Char -> Bool
isUpper = isUpper

-- | Selects alphabetic Unicode characters (lower-case, upper-case and title-case letters, plus letters of caseless
-- scripts and modifiers letters). This function is equivalent to @Data.Char.isLetter@.
isAlpha :: Char -> Bool
isAlpha = isAlpha

-- | Selects alphabetic or numeric digit Unicode characters.
--
-- Note that numeric digits outside the ASCII range are selected by this function but not by isDigit.
-- Such digits may be part of identifiers but are not used by the printer and reader to represent numbers.
isAlphaNum :: Char -> Bool
isAlphaNum = isAlphaNum

-- | Selects printable Unicode characters (letters, numbers, marks, punctuation, symbols and spaces)
isPrint :: Char -> Bool
isPrint = isPrint

-- | Selects ASCII digits, i.e. @’0’..’9’@.
isDigit :: Char -> Bool
isDigit = isDigit

-- | Selects ASCII octal digits, i.e. @’0’..’7’@.
isOctDigit :: Char -> Bool
isOctDigit = isOctDigit

-- | Selects ASCII hexadecimal digits, i.e. @’0’..’9’@, @’a’..’f’@, @’A’..’F’@.
isHexDigit :: Char -> Bool
isHexDigit = isHexDigit

-- | Selects alphabetic Unicode characters (lower-case, upper-case and title-case letters, plus letters of caseless
-- scripts and modifiers letters). This function is equivalent to @Data.Char.isAlpha@.
isLetter :: Char -> Bool
isLetter = isLetter

-- | Selects Unicode mark characters, e.g. accents and the like, which combine with preceding letters.
isMark :: Char -> Bool
isMark = isMark

-- | Selects Unicode numeric characters, including digits from various scripts, Roman numerals, etc.
isNumber :: Char -> Bool
isNumber = isNumber

-- | Selects Unicode punctuation characters, including various kinds of connectors, brackets and quotes.
isPunctuation :: Char -> Bool
isPunctuation = isPunctuation

-- | Selects Unicode symbol characters, including mathematical and currency symbols.
isSymbol :: Char -> Bool
isSymbol = isSymbol

-- | Selects Unicode space and separator characters.
isSeparator :: Char -> Bool
isSeparator = isSeparator

-- | Selects the first 128 characters of the Unicode character set, corresponding to the ASCII character set.
isAscii :: Char -> Bool
isAscii = isAscii

-- | Selects the first 256 characters of the Unicode character set, corresponding to the ISO 8859-1 (Latin-1)
-- character set.
isLatin1 :: Char -> Bool
isLatin1 = isLatin1

-- | Selects ASCII upper-case letters, i.e. characters satisfying both @isAscii@ and @isUpper@.
isAsciiUpper :: Char -> Bool
isAsciiUpper = isAsciiUpper

-- | Selects ASCII lower-case letters, i.e. characters satisfying both @isAscii@ and @isLower@.
isAsciiLower :: Char -> Bool
isAsciiLower = isAsciiLower

-- | Unicode General Categories (column 2 of the UnicodeData table) in the order they are listed in the
-- Unicode standard.
data GeneralCategory
  = -- | Lu: Letter, Uppercase
    UppercaseLetter
  | -- | Ll: Letter, Lowercase
    LowercaseLetter
  | -- | Lt: Letter, Titlecase
    TitlecaseLetter
  | -- | Lm: Letter, Modifier
    ModifierLetter
  | -- | Lo: Letter, Other
    OtherLetter
  | -- | Mn: Mark, Non-Spacing
    NonSpacingMark
  | -- | Mc: Mark, Spacing Combining
    SpacingCombiningMark
  | -- | Me: Mark, Enclosing
    EnclosingMark
  | -- | Nd: Number, Decimal
    DecimalNumber
  | -- | Nl: Number, Letter
    LetterNumber
  | -- | No: Number, Other
    OtherNumber
  | -- | Pc: Punctuation, Connector
    ConnectorPunctuation
  | -- | Pd: Punctuation, Dash
    DashPunctuation
  | -- | Ps: Punctuation, Open
    OpenPunctuation
  | -- | Pe: Punctuation, Close
    ClosePunctuation
  | -- | Pi: Punctuation, Initial quote
    InitialQuote
  | -- | Pf: Punctuation, Final quote
    FinalQuote
  | -- | Po: Punctuation, Other
    OtherPunctuation
  | -- | Sm: Symbol, Math
    MathSymbol
  | -- | Sc: Symbol, Currency
    CurrencySymbol
  | -- | Sk: Symbol, Modifier
    ModifierSymbol
  | -- | So: Symbol, Other
    OtherSymbol
  | -- | Zs: Separator, Space
    Space
  | -- | Zl: Separator, Line
    LineSeparator
  | -- | Zp: Separator, Paragraph
    ParagraphSeparator
  | -- | Cc: Other, Control
    Control
  | -- | Cf: Other, Format
    Format
  | -- | Cs: Other, Surrogate
    Surrogate
  | -- | Co: Other, Private Use
    PrivateUse
  | -- | Cn: Other, Not Assigned
    NotAssigned

instance Bounded GeneralCategory

instance Enum GeneralCategory

instance Eq GeneralCategory

instance Ord GeneralCategory

instance Read GeneralCategory

instance Show GeneralCategory

instance Ix GeneralCategory

-- | The Unicode general category of the character.
generalCategory :: Char -> GeneralCategory
generalCategory = generalCategory

-- | Convert a letter to the corresponding upper-case letter, if any. Any other character is returned un-
-- changed.
toUpper :: Char -> Char
toUpper = toUpper

-- | Convert a letter to the corresponding lower-case letter, if any. Any other character is returned un-
-- changed.
toLower :: Char -> Char
toLower = toLower

-- | Convert a letter to the corresponding title-case or upper-case letter, if any. (Title case differs from upper
-- case only for a small number of ligature letters.) Any other character is returned unchanged.
toTitle :: Char -> Char
toTitle = toTitle

-- | Convert a single digit @Char@ to the corresponding @Int@. This function fails unless its argument satisfies
-- @isHexDigit@, but recognises both upper and lower-case hexadecimal digits (i.e. @’0’..’9’@, @’a’..’f’@,
-- @’A’..’F’@).
digitToInt :: Char -> Int
digitToInt = digitToInt

-- | Convert an @Int@ in the range @0..15@ to the corresponding single digit @Char@. This function fails on other
-- inputs, and generates lower-case hexadecimal digits
intToDigit :: Int -> Char
intToDigit = intToDigit

-- | The @Prelude.fromEnum@ method restricted to the type @Data.Char.Char@
ord :: Char -> Int
ord = ord

-- | The @Prelude.toEnum@ method restricted to the type @Data.Char.Char@.
chr :: Int -> Char
chr = chr

-- | Convert a character to a string using only printable characters, using Haskell source-language escape
-- conventions. For example:
--
-- @
-- showLitChar ’\n’ s = "\\n" ++ s
-- @
showLitChar :: Char -> ShowS
showLitChar = showLitChar

-- | Read a string representation of a character, using Haskell source-language escape conventions. For
-- example:
--
-- @
-- lexLitChar "\\nHello" = [("\\n", "Hello")]
-- @
lexLitChar :: ReadS String
lexLitChar = lexLitChar

-- | Read a string representation of a character, using Haskell source-language escape conventions, and
-- convert it to the character that it encodes. For example:
--
-- @
-- readLitChar "\\nHello" = [(’\n’, "Hello")]
-- @
readLitChar :: ReadS Char
readLitChar = readLitChar