-- |
-- Module: Foreign.C
--
-- The module @Foreign.C@ combines the interfaces of all modules providing C-specific marshalling support, namely
module Foreign.C
  ( module Foreign.C.Types,
    module Foreign.C.String,
    module Foreign.C.Error,
  )
where

import Foreign.C.Error
import Foreign.C.String
import Foreign.C.Types
