-- |
-- Module: Foreign.C.Types
module Foreign.C.Types
  ( -- * Representations of C types

    -- ** Integral types

    -- | These types are are represented as @newtype@s of types in @Data.Int@ and @Data.Word@, and are instances of
    -- 'Eq', 'Ord', 'Num', 'Read', 'Show', 'Enum', 'Storable', 'Bounded', 'Real', 'Integral' and 'Bits'.
    CChar,
    CSChar,
    CUChar,
    CShort,
    CUShort,
    CInt,
    CUInt,
    CLong,
    CULong,
    CPtrdiff,
    CSize,
    CWchar,
    CSigAtomic,
    CLLong,
    CULLong,
    CIntPtr,
    CUIntPtr,
    CIntMax,
    CUIntMax,

    -- ** Numeric types
    CClock,
    CTime,

    -- ** Floating types
    CFloat,
    CDouble,

    -- ** Other types
    CFile,
    CFpos,
    CJmpBuf,
  )
where

import Data.Bits
import Data.Enum
import Data.Eq
import Data.Ord
import Foreign.Storable
import NumHierarchy
import Text.Read
import Text.Show

-- | Haskell type representing the C @char@ type.
data CChar = AbstractCCHar

instance Bounded CChar

instance Enum CChar

instance Eq CChar

instance Integral CChar

instance Num CChar

instance Ord CChar

instance Read CChar

instance Real CChar

instance Show CChar

instance Storable CChar

instance Bits CChar

-- | Haskell type representing the C @signed char@ type.
data CSChar = AbstractCSChar

instance Bounded CSChar

instance Enum CSChar

instance Eq CSChar

instance Integral CSChar

instance Num CSChar

instance Ord CSChar

instance Read CSChar

instance Real CSChar

instance Show CSChar

instance Storable CSChar

instance Bits CSChar

-- | Haskell type representing the C @unsigned char@ type.
data CUChar = AbstractCUChar

instance Bounded CUChar

instance Enum CUChar

instance Eq CUChar

instance Integral CUChar

instance Num CUChar

instance Ord CUChar

instance Read CUChar

instance Real CUChar

instance Show CUChar

instance Storable CUChar

instance Bits CUChar

-- | Haskell type representing the C @short@ type.
data CShort = AbstractCShort

instance Bounded CShort

instance Enum CShort

instance Eq CShort

instance Integral CShort

instance Num CShort

instance Ord CShort

instance Read CShort

instance Real CShort

instance Show CShort

instance Storable CShort

instance Bits CShort

-- | Haskell type representing the C @unsigned short@ type.
data CUShort = AbstractCUShort

instance Bounded CUShort

instance Enum CUShort

instance Eq CUShort

instance Integral CUShort

instance Num CUShort

instance Ord CUShort

instance Read CUShort

instance Real CUShort

instance Show CUShort

instance Storable CUShort

instance Bits CUShort

-- | Haskell type representing the C @int@ type.
data CInt = AbstractCInt

instance Bounded CInt

instance Enum CInt

instance Eq CInt

instance Integral CInt

instance Num CInt

instance Ord CInt

instance Read CInt

instance Real CInt

instance Show CInt

instance Storable CInt

instance Bits CInt

-- | Haskell type representing the C @unsigned int@ type.
data CUInt = AbstractCUInt

instance Bounded CUInt

instance Enum CUInt

instance Eq CUInt

instance Integral CUInt

instance Num CUInt

instance Ord CUInt

instance Read CUInt

instance Real CUInt

instance Show CUInt

instance Storable CUInt

instance Bits CUInt

-- | Haskell type representing the C @long@ type.
data CLong = AbstractCLong

instance Bounded CLong

instance Enum CLong

instance Eq CLong

instance Integral CLong

instance Num CLong

instance Ord CLong

instance Read CLong

instance Real CLong

instance Show CLong

instance Storable CLong

instance Bits CLong

-- | Haskell type representing the C @unsigned long@ type.
data CULong = AbstractCULong

instance Bounded CULong

instance Enum CULong

instance Eq CULong

instance Integral CULong

instance Num CULong

instance Ord CULong

instance Read CULong

instance Real CULong

instance Show CULong

instance Storable CULong

instance Bits CULong

-- | Haskell type representing the C @ptrdiff_t@ type.
data CPtrdiff = AbstractCPtrdiff

instance Bounded CPtrdiff

instance Enum CPtrdiff

instance Eq CPtrdiff

instance Integral CPtrdiff

instance Num CPtrdiff

instance Ord CPtrdiff

instance Read CPtrdiff

instance Real CPtrdiff

instance Show CPtrdiff

instance Storable CPtrdiff

instance Bits CPtrdiff

-- | Haskell type representing the C @size_t@ type.
data CSize = AbstractCSize

instance Bounded CSize

instance Enum CSize

instance Eq CSize

instance Integral CSize

instance Num CSize

instance Ord CSize

instance Read CSize

instance Real CSize

instance Show CSize

instance Storable CSize

instance Bits CSize

-- | Haskell type representing the C @wchar_t@ type.
data CWchar = AbstractCWchar

instance Bounded CWchar

instance Enum CWchar

instance Eq CWchar

instance Integral CWchar

instance Num CWchar

instance Ord CWchar

instance Read CWchar

instance Real CWchar

instance Show CWchar

instance Storable CWchar

instance Bits CWchar

-- | Haskell type representing the C @sig_atomic_t@ type.
data CSigAtomic = AbstractCSigAtomic

instance Bounded CSigAtomic

instance Enum CSigAtomic

instance Eq CSigAtomic

instance Integral CSigAtomic

instance Num CSigAtomic

instance Ord CSigAtomic

instance Read CSigAtomic

instance Real CSigAtomic

instance Show CSigAtomic

instance Storable CSigAtomic

instance Bits CSigAtomic

-- | Haskell type representing the C @long long@ type.
data CLLong = AbstractCLLong

instance Bounded CLLong

instance Enum CLLong

instance Eq CLLong

instance Integral CLLong

instance Num CLLong

instance Ord CLLong

instance Read CLLong

instance Real CLLong

instance Show CLLong

instance Storable CLLong

instance Bits CLLong

-- | Haskell type representing the C @unsigned long long@ type.
data CULLong = AbstractCULLong

instance Bounded CULLong

instance Enum CULLong

instance Eq CULLong

instance Integral CULLong

instance Num CULLong

instance Ord CULLong

instance Read CULLong

instance Real CULLong

instance Show CULLong

instance Storable CULLong

instance Bits CULLong

data CIntPtr = AbstractCIntPtr

instance Bounded CIntPtr

instance Enum CIntPtr

instance Eq CIntPtr

instance Integral CIntPtr

instance Num CIntPtr

instance Ord CIntPtr

instance Read CIntPtr

instance Real CIntPtr

instance Show CIntPtr

instance Storable CIntPtr

instance Bits CIntPtr

data CUIntPtr = AbstractCUIntPtr

instance Bounded CUIntPtr

instance Enum CUIntPtr

instance Eq CUIntPtr

instance Integral CUIntPtr

instance Num CUIntPtr

instance Ord CUIntPtr

instance Read CUIntPtr

instance Real CUIntPtr

instance Show CUIntPtr

instance Storable CUIntPtr

instance Bits CUIntPtr

data CIntMax = AbstractCIntMax

instance Bounded CIntMax

instance Enum CIntMax

instance Eq CIntMax

instance Integral CIntMax

instance Num CIntMax

instance Ord CIntMax

instance Read CIntMax

instance Real CIntMax

instance Show CIntMax

instance Storable CIntMax

instance Bits CIntMax

data CUIntMax = AbstractCUIntMax

instance Bounded CUIntMax

instance Enum CUIntMax

instance Eq CUIntMax

instance Integral CUIntMax

instance Num CUIntMax

instance Ord CUIntMax

instance Read CUIntMax

instance Real CUIntMax

instance Show CUIntMax

instance Storable CUIntMax

instance Bits CUIntMax

-- | Haskell type representing the C @clock_t@ type.
data CClock = AbstractCClock

instance Enum CClock

instance Eq CClock

instance Num CClock

instance Ord CClock

instance Read CClock

instance Real CClock

instance Show CClock

instance Storable CClock

-- | Haskell type representing the C @time_t@ type.
data CTime = AbstractCTime

instance Enum CTime

instance Eq CTime

instance Num CTime

instance Ord CTime

instance Read CTime

instance Real CTime

instance Show CTime

instance Storable CTime

-- | Haskell type representing the C @float@ type.
data CFloat = AbstractCFloat

instance Enum CFloat

instance Eq CFloat

instance Floating CFloat

instance Fractional CFloat

instance Num CFloat

instance Ord CFloat

instance Read CFloat

instance Real CFloat

instance RealFloat CFloat

instance RealFrac CFloat

instance Show CFloat

instance Storable CFloat

-- | Haskell type representing the C @double@ type.
data CDouble = AbstractCDouble

instance Enum CDouble

instance Eq CDouble

instance Floating CDouble

instance Fractional CDouble

instance Num CDouble

instance Ord CDouble

instance Read CDouble

instance Real CDouble

instance RealFloat CDouble

instance RealFrac CDouble

instance Show CDouble

instance Storable CDouble

-- | Haskell type representing the C @FILE@ type.
data CFile = AbstractCFile

-- | Haskell type representing the C @fpos_t@ type.
data CFpos = AbstractCFpos

-- | Haskell type representing the C @jmp_buf@ type.
data CJmpBuf = AbstractCJmpBuf