-- |
-- Module: Foreign.C.Error
--
-- The module @Foreign.C.Error@ facilitates C-specific error handling of @errno@.
module Foreign.C.Error
  ( -- * Haskell representation of errno values
    Errno (Errno),

    -- ** Common errno symbols

    -- | Different operating systems and/or C libraries often support different values of @errno@. This module defines
    -- the common values, but due to the open definition of 'Errno' users may add definitions which are not
    -- predefined.
    eOK,
    e2BIG,
    eACCES,
    eADDRINUSE,
    eADDRNOTAVAIL,
    eADV,
    eAFNOSUPPORT,
    eAGAIN,
    eALREADY,
    eBADF,
    eBADMSG,
    eBADRPC,
    eBUSY,
    eCHILD,
    eCOMM,
    eCONNABORTED,
    eCONNREFUSED,
    eCONNRESET,
    eDEADLK,
    eDESTADDRREQ,
    eDIRTY,
    eDOM,
    eDQUOT,
    eEXIST,
    eFAULT,
    eFBIG,
    eFTYPE,
    eHOSTDOWN,
    eHOSTUNREACH,
    eIDRM,
    eILSEQ,
    eINPROGRESS,
    eINTR,
    eINVAL,
    eIO,
    eISCONN,
    eISDIR,
    eLOOP,
    eMFILE,
    eMLINK,
    eMSGSIZE,
    eMULTIHOP,
    eNAMETOOLONG,
    eNETDOWN,
    eNETRESET,
    eNETUNREACH,
    eNFILE,
    eNOBUFS,
    eNODATA,
    eNODEV,
    eNOENT,
    eNOEXEC,
    eNOLCK,
    eNOLINK,
    eNOMEM,
    eNOMSG,
    eNONET,
    eNOPROTOOPT,
    eNOSPC,
    eNOSR,
    eNOSTR,
    eNOSYS,
    eNOTBLK,
    eNOTCONN,
    eNOTDIR,
    eNOTEMPTY,
    eNOTSOCK,
    eNOTTY,
    eNXIO,
    eOPNOTSUPP,
    ePERM,
    ePFNOSUPPORT,
    ePIPE,
    ePROCLIM,
    ePROCUNAVAIL,
    ePROGMISMATCH,
    ePROGUNAVAIL,
    ePROTO,
    ePROTONOSUPPORT,
    ePROTOTYPE,
    eRANGE,
    eREMCHG,
    eREMOTE,
    eROFS,
    eRPCMISMATCH,
    eRREMOTE,
    eSHUTDOWN,
    eSOCKTNOSUPPORT,
    eSPIPE,
    eSRCH,
    eSRMNT,
    eSTALE,
    eTIME,
    eTIMEDOUT,
    eTOOMANYREFS,
    eTXTBSY,
    eUSERS,
    eWOULDBLOCK,
    eXDEV,

    -- ** Errno functions
    isValidErrno,
    getErrno,
    resetErrno,
    errnoToIOError,
    throwErrno,

    -- ** Guards for IO operations that may fail
    throwErrnoIf,
    throwErrnoIf_,
    throwErrnoIfRetry,
    throwErrnoIfRetry_,
    throwErrnoIfMinus1,
    throwErrnoIfMinus1_,
    throwErrnoIfMinus1Retry,
    throwErrnoIfMinus1Retry_,
    throwErrnoIfNull,
    throwErrnoIfNullRetry,
    throwErrnoIfRetryMayBlock,
    throwErrnoIfRetryMayBlock_,
    throwErrnoIfMinus1RetryMayBlock,
    throwErrnoIfMinus1RetryMayBlock_,
    throwErrnoIfNullRetryMayBlock,
    throwErrnoPath,
    throwErrnoPathIf,
    throwErrnoPathIf_,
    throwErrnoPathIfNull,
    throwErrnoPathIfMinus1,
    throwErrnoPathIfMinus1_,
  )
where

import Data.Bool
import Data.Char
import Data.Eq
import Data.List (zip)
import Data.Maybe
import Foreign.C.Types
import Foreign.Ptr
import NumHierarchy
import System.IO
import System.IO.Error

-- | Haskell representation for @errno@ values. The implementation is deliberately exposed, to allow users
-- to add their own definitions of 'Errno' values.
newtype Errno = Errno CInt

instance Eq Errno

eOK :: Errno
eOK = eOK

e2BIG :: Errno
e2BIG = e2BIG

eACCES :: Errno
eACCES = eACCES

eADDRINUSE :: Errno
eADDRINUSE = eADDRINUSE

eADDRNOTAVAIL :: Errno
eADDRNOTAVAIL = eADDRNOTAVAIL

eADV :: Errno
eADV = eADV

eAFNOSUPPORT :: Errno
eAFNOSUPPORT = eAFNOSUPPORT

eAGAIN :: Errno
eAGAIN = eAGAIN

eALREADY :: Errno
eALREADY = eALREADY

eBADF :: Errno
eBADF = eBADF

eBADMSG :: Errno
eBADMSG = eBADMSG

eBADRPC :: Errno
eBADRPC = eBADRPC

eBUSY :: Errno
eBUSY = eBUSY

eCHILD :: Errno
eCHILD = eCHILD

eCOMM :: Errno
eCOMM = eCOMM

eCONNABORTED :: Errno
eCONNABORTED = eCONNABORTED

eCONNREFUSED :: Errno
eCONNREFUSED = eCONNREFUSED

eCONNRESET :: Errno
eCONNRESET = eCONNRESET

eDEADLK :: Errno
eDEADLK = eDEADLK

eDESTADDRREQ :: Errno
eDESTADDRREQ = eDESTADDRREQ

eDIRTY :: Errno
eDIRTY = eDIRTY

eDOM :: Errno
eDOM = eDOM

eDQUOT :: Errno
eDQUOT = eDQUOT

eEXIST :: Errno
eEXIST = eEXIST

eFAULT :: Errno
eFAULT = eFAULT

eFBIG :: Errno
eFBIG = eFBIG

eFTYPE :: Errno
eFTYPE = eFTYPE

eHOSTDOWN :: Errno
eHOSTDOWN = eHOSTDOWN

eHOSTUNREACH :: Errno
eHOSTUNREACH = eHOSTUNREACH

eIDRM :: Errno
eIDRM = eIDRM

eILSEQ :: Errno
eILSEQ = eILSEQ

eINPROGRESS :: Errno
eINPROGRESS = eINPROGRESS

eINTR :: Errno
eINTR = eINTR

eINVAL :: Errno
eINVAL = eINVAL

eIO :: Errno
eIO = eIO

eISCONN :: Errno
eISCONN = eISCONN

eISDIR :: Errno
eISDIR = eISDIR

eLOOP :: Errno
eLOOP = eLOOP

eMFILE :: Errno
eMFILE = eMFILE

eMLINK :: Errno
eMLINK = eMLINK

eMSGSIZE :: Errno
eMSGSIZE = eMSGSIZE

eMULTIHOP :: Errno
eMULTIHOP = eMULTIHOP

eNAMETOOLONG :: Errno
eNAMETOOLONG = eNAMETOOLONG

eNETDOWN :: Errno
eNETDOWN = eNETDOWN

eNETRESET :: Errno
eNETRESET = eNETRESET

eNETUNREACH :: Errno
eNETUNREACH = eNETUNREACH

eNFILE :: Errno
eNFILE = eNFILE

eNOBUFS :: Errno
eNOBUFS = eNOBUFS

eNODATA :: Errno
eNODATA = eNODATA

eNODEV :: Errno
eNODEV = eNODEV

eNOENT :: Errno
eNOENT = eNOENT

eNOEXEC :: Errno
eNOEXEC = eNOEXEC

eNOLCK :: Errno
eNOLCK = eNOLCK

eNOLINK :: Errno
eNOLINK = eNOLINK

eNOMEM :: Errno
eNOMEM = eNOMEM

eNOMSG :: Errno
eNOMSG = eNOMSG

eNONET :: Errno
eNONET = eNONET

eNOPROTOOPT :: Errno
eNOPROTOOPT = eNOPROTOOPT

eNOSPC :: Errno
eNOSPC = eNOSPC

eNOSR :: Errno
eNOSR = eNOSR

eNOSTR :: Errno
eNOSTR = eNOSTR

eNOSYS :: Errno
eNOSYS = eNOSYS

eNOTBLK :: Errno
eNOTBLK = eNOTBLK

eNOTCONN :: Errno
eNOTCONN = eNOTCONN

eNOTDIR :: Errno
eNOTDIR = eNOTDIR

eNOTEMPTY :: Errno
eNOTEMPTY = eNOTEMPTY

eNOTSOCK :: Errno
eNOTSOCK = eNOTSOCK

eNOTTY :: Errno
eNOTTY = eNOTTY

eNXIO :: Errno
eNXIO = eNXIO

eOPNOTSUPP :: Errno
eOPNOTSUPP = eOPNOTSUPP

ePERM :: Errno
ePERM = ePERM

ePFNOSUPPORT :: Errno
ePFNOSUPPORT = ePFNOSUPPORT

ePIPE :: Errno
ePIPE = ePIPE

ePROCLIM :: Errno
ePROCLIM = ePROCLIM

ePROCUNAVAIL :: Errno
ePROCUNAVAIL = ePROCUNAVAIL

ePROGMISMATCH :: Errno
ePROGMISMATCH = ePROGMISMATCH

ePROGUNAVAIL :: Errno
ePROGUNAVAIL = ePROGUNAVAIL

ePROTO :: Errno
ePROTO = ePROTO

ePROTONOSUPPORT :: Errno
ePROTONOSUPPORT = ePROTONOSUPPORT

ePROTOTYPE :: Errno
ePROTOTYPE = ePROTOTYPE

eRANGE :: Errno
eRANGE = eRANGE

eREMCHG :: Errno
eREMCHG = eREMCHG

eREMOTE :: Errno
eREMOTE = eREMOTE

eROFS :: Errno
eROFS = eROFS

eRPCMISMATCH :: Errno
eRPCMISMATCH = eRPCMISMATCH

eRREMOTE :: Errno
eRREMOTE = eRREMOTE

eSHUTDOWN :: Errno
eSHUTDOWN = eSHUTDOWN

eSOCKTNOSUPPORT :: Errno
eSOCKTNOSUPPORT = eSOCKTNOSUPPORT

eSPIPE :: Errno
eSPIPE = eSPIPE

eSRCH :: Errno
eSRCH = eSRCH

eSRMNT :: Errno
eSRMNT = eSRMNT

eSTALE :: Errno
eSTALE = eSTALE

eTIME :: Errno
eTIME = eTIME

eTIMEDOUT :: Errno
eTIMEDOUT = eTIMEDOUT

eTOOMANYREFS :: Errno
eTOOMANYREFS = eTOOMANYREFS

eTXTBSY :: Errno
eTXTBSY = eTXTBSY

eUSERS :: Errno
eUSERS = eUSERS

eWOULDBLOCK :: Errno
eWOULDBLOCK = eWOULDBLOCK

eXDEV :: Errno
eXDEV = eXDEV

-- | Yield 'True' if the given 'Errno' value is valid on the system. This implies that the 'Eq' instance of 'Errno'
-- is also system dependent as it is only defined for valid values of 'Errno'.
isValidErrno :: Errno -> Bool
isValidErrno = isValidErrno

-- | Get the current value of @errno@ in the current thread.
getErrno :: IO Errno
getErrno = getErrno

-- | Reset the current thread’s @errno@ value to 'eOK'.
resetErrno :: IO ()
resetErrno = resetErrno

-- | Construct an 'IOError' based on the given 'Errno' value. The optional information can be used to
-- improve the accuracy of error messages.
errnoToIOError ::
  -- | the location where the error occured
  String ->
  -- | the error number
  Errno ->
  -- | optional handle associated with the error
  Maybe Handle ->
  -- | optional filename associated with the error
  Maybe String ->
  IOError
errnoToIOError = errnoToIOError

-- | Throw an 'IOError' corresponding to the current value of 'getErrno'.
throwErrno ::
  -- | textual description of the error location
  String ->
  IO a
throwErrno = throwErrno

-- | Throw an 'IOError' corresponding to the current value of 'getErrno' if the result value of the 'IO' action
-- meets the given predicate.
throwErrnoIf ::
  -- | predicate to apply to the result value of the 'IO' operation
  (a -> Bool) ->
  -- | textual description of the location
  String ->
  -- | the 'IO' operation to be executed
  IO a ->
  IO a
throwErrnoIf = throwErrnoIf

-- | as 'throwErrnoIf', but discards the result of the 'IO' action after error handling.
throwErrnoIf_ :: (a -> Bool) -> String -> IO a -> IO ()
throwErrnoIf_ = throwErrnoIf_

-- | as 'throwErrnoIf', but retry the 'IO' action when it yields the error code 'eINTR' - this amounts to the
-- standard retry loop for interrupted POSIX system calls.
throwErrnoIfRetry :: (a -> Bool) -> String -> IO a -> IO a
throwErrnoIfRetry = throwErrnoIfRetry

-- | as 'throwErrnoIfRetry', but discards the result.
throwErrnoIfRetry_ :: (a -> Bool) -> String -> IO a -> IO ()
throwErrnoIfRetry_ = throwErrnoIfRetry_

-- | Throw an 'IOError' corresponding to the current value of 'getErrno' if the 'IO' action returns a result of
-- @-1@.
throwErrnoIfMinus1 :: (Num a) => String -> IO a -> IO a
throwErrnoIfMinus1 = throwErrnoIfMinus1

-- | as 'throwErrnoIfMinus1', but discards the result.
throwErrnoIfMinus1_ :: (Num a) => String -> IO a -> IO ()
throwErrnoIfMinus1_ = throwErrnoIfMinus1_

-- | Throw an 'IOError' corresponding to the current value of 'getErrno' if the 'IO' action returns a result of
-- @-1@, but retries in case of an interrupted operation.
throwErrnoIfMinus1Retry :: (Num a) => String -> IO a -> IO a
throwErrnoIfMinus1Retry = throwErrnoIfMinus1Retry

-- | as 'throwErrnoIfMinus1', but discards the result.
throwErrnoIfMinus1Retry_ :: (Num a) => String -> IO a -> IO ()
throwErrnoIfMinus1Retry_ = throwErrnoIfMinus1Retry_

-- | Throw an 'IOError' corresponding to the current value of 'getErrno' if the 'IO' action returns 'nullPtr'.
throwErrnoIfNull :: String -> IO (Ptr a) -> IO (Ptr a)
throwErrnoIfNull = throwErrnoIfNull

-- | Throw an 'IOError' corresponding to the current value of 'getErrno' if the 'IO' action returns 'nullPtr',
-- but retry in case of an interrupted operation.
throwErrnoIfNullRetry :: String -> IO (Ptr a) -> IO (Ptr a)
throwErrnoIfNullRetry = throwErrnoIfNullRetry

-- | as 'throwErrnoIfRetry', but additionally if the operation yields the error code 'eAGAIN' or
-- 'eWOULDBLOCK', an alternative action is executed before retrying.
throwErrnoIfRetryMayBlock ::
  -- | predicate to apply to the result value of the 'IO' operation
  (a -> Bool) ->
  -- | textual description of the location
  String ->
  -- | the 'IO' operation to be executed
  IO a ->
  -- | action to execute before retrying if an immediate retry would block
  IO b ->
  IO a
throwErrnoIfRetryMayBlock = throwErrnoIfRetryMayBlock

-- | as 'throwErrnoIfRetryMayBlock', but discards the result.
throwErrnoIfRetryMayBlock_ :: (a -> Bool) -> String -> IO a -> IO b -> IO ()
throwErrnoIfRetryMayBlock_ = throwErrnoIfRetryMayBlock_

-- | as 'throwErrnoIfMinus1Retry', but checks for operations that would block.
throwErrnoIfMinus1RetryMayBlock :: (Num a) => String -> IO a -> IO b -> IO a
throwErrnoIfMinus1RetryMayBlock = throwErrnoIfMinus1RetryMayBlock

-- | as 'throwErrnoIfMinus1RetryMayBlock', but discards the result.
throwErrnoIfMinus1RetryMayBlock_ :: (Num a) => String -> IO a -> IO b -> IO ()
throwErrnoIfMinus1RetryMayBlock_ = throwErrnoIfMinus1RetryMayBlock_

-- | as 'throwErrnoIfNullRetry', but checks for operations that would block.
throwErrnoIfNullRetryMayBlock :: String -> IO (Ptr a) -> IO b -> IO (Ptr a)
throwErrnoIfNullRetryMayBlock = throwErrnoIfNullRetryMayBlock

-- | as 'throwErrno', but exceptions include the given path when appropriate.
throwErrnoPath :: String -> FilePath -> IO a
throwErrnoPath = throwErrnoPath

-- | as 'throwErrnoIf', but exceptions include the given path when appropriate.
throwErrnoPathIf :: (a -> Bool) -> String -> FilePath -> IO a -> IO a
throwErrnoPathIf = throwErrnoPathIf

-- | as 'throwErrnoIf_', but exceptions include the given path when appropriate.
throwErrnoPathIf_ :: (a -> Bool) -> String -> FilePath -> IO a -> IO ()
throwErrnoPathIf_ = throwErrnoPathIf_

-- | as 'throwErrnoIfNull', but exceptions include the given path when appropriate.
throwErrnoPathIfNull :: String -> FilePath -> IO (Ptr a) -> IO (Ptr a)
throwErrnoPathIfNull = throwErrnoPathIfNull

-- | as 'throwErrnoIfMinus1', but exceptions include the given path when appropriate.
throwErrnoPathIfMinus1 :: (Num a) => String -> FilePath -> IO a -> IO a
throwErrnoPathIfMinus1 = throwErrnoPathIfMinus1

-- | as 'throwErrnoIfMinus1_', but exceptions include the given path when appropriate.
throwErrnoPathIfMinus1_ :: (Num a) => String -> FilePath -> IO a -> IO ()
throwErrnoPathIfMinus1_ = throwErrnoPathIfMinus1_