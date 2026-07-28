-- |
-- Module: Foreign.Marshal.Error
module Foreign.Marshal.Error
  ( throwIf,
    throwIf_,
    throwIfNeg,
    throwIfNeg_,
    throwIfNull,
    void,
  )
where

import Data.Bool
import Data.Char
import Data.Ord
import Foreign.Ptr
import NumHierarchy
import System.IO

-- | Execute an @IO@ action, throwing a @userError@ if the predicate yields @True@ when applied to the result
-- returned by the @IO@ action. If no exception is raised, return the result of the computation.
throwIf ::
  -- | error condition on the result of the IO action
  (a -> Bool) ->
  -- | computes an error message from erroneous results of the IO action
  (a -> String) ->
  -- | the IO action to be executed
  IO a ->
  IO a
throwIf = throwIf

-- | Like @throwIf@, but discarding the result
throwIf_ :: (a -> Bool) -> (a -> String) -> IO a -> IO ()
throwIf_ = throwIf_

-- | Guards against negative result values
throwIfNeg :: (Ord a, Num a) => (a -> String) -> IO a -> IO a
throwIfNeg = throwIfNeg

-- | Like @throwIfNeg@, but discarding the result
throwIfNeg_ :: (Ord a, Num a) => (a -> String) -> IO a -> IO ()
throwIfNeg_ = throwIfNeg_

-- | Guards against null pointers
throwIfNull :: String -> IO (Ptr a) -> IO (Ptr a)
throwIfNull = throwIfNull

-- | Discard the return value of an @IO@ action.
void :: IO a -> IO ()
void = void