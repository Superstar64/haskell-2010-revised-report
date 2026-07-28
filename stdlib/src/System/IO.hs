module System.IO
  ( -- * The IO monad
    IO,
    fixIO,

    -- * Files and handles
    FilePath,
    Handle,

    -- * Standard handles

    -- | Three handles are allocated during program initialisation, and are initially open.
    stdin,
    stdout,
    stderr,

    -- * Opening and closing files

    -- ** Opening files
    withFile,
    openFile,
    IOMode (ReadMode, WriteMode, AppendMode, ReadWriteMode),

    -- ** Closing files
    hClose,

    -- ** Special cases

    -- | These functions are also exported by the 'Prelude'.
    readFile,
    writeFile,
    appendFile,

    -- ** File locking

    -- | Implementations should enforce as far as possible, at least locally to the Haskell process, multiple-reader
    -- single-writer locking on files. That is, /there may either be many handles on the same file which manage/
    -- /input, or just one handle on the file which manages output/. If any open or semi-closed handle is managing a
    -- file for output, no new handle can be allocated for that file. If any open or semi-closed handle is managing
    -- a file for input, new handles can only be allocated if they do not manage output. Whether two files are the
    -- same is implementation-dependent, but they should normally be the same if they have the same absolute path
    -- name and neither has been renamed, for example.
    --
    -- Warning: the 'readFile' operation holds a semi-closed handle on the file until the entire contents of the file
    -- have been consumed. It follows that an attempt to write to a file (using 'writeFile', for example) that was earlier
    -- opened by 'readFile' will usually result in failure with 'System.IO.Error.isAlreadyInUseError'.

    -- * Operations on handles

    -- ** Determining and changing the size of a file
    hFileSize,
    hSetFileSize,

    -- ** Detecting the end of input
    hIsEOF,
    isEOF,

    -- ** Buffering operations
    BufferMode (NoBuffering, LineBuffering, BlockBuffering),
    hSetBuffering,
    hGetBuffering,
    hFlush,

    -- ** Repositioning handles
    hGetPosn,
    hSetPosn,
    HandlePosn,
    hSeek,
    SeekMode (AbsoluteSeek, RelativeSeek, SeekFromEnd),
    hTell,

    -- ** Handle properties

    -- | Each of these operations returns 'True' if the handle has the the specified property, or 'False' otherwise.
    hIsOpen,
    hIsClosed,
    hIsReadable,
    hIsWritable,
    hIsSeekable,

    -- ** Terminal operations
    hIsTerminalDevice,
    hSetEcho,
    hGetEcho,

    -- ** Showing handle state
    hShow,

    -- * Text input and output

    -- ** Text input
    hWaitForInput,
    hReady,
    hGetChar,
    hGetLine,
    hLookAhead,
    hGetContents,

    -- ** Text output
    hPutChar,
    hPutStr,
    hPutStrLn,
    hPrint,

    -- ** Special cases for standard input and output

    -- | These functions are also exported by the 'Prelude'.
    interact,
    putChar,
    putStr,
    putStrLn,
    print,
    getChar,
    getLine,
    getContents,
    readIO,
    readLn,
  )
where

import Data.Bool
import Data.Char
import Data.Enum
import Data.Eq
import Data.Int
import Data.Ix
import Data.Maybe
import Data.Ord
import Prim
import Text.Read
import Text.Show

-- | A value of type @IO a@ is a computation which, when performed, does some I/O before returning a value
-- of type @a@.
--
-- There is really only one way to "perform" an I/O action: bind it to @Main.main@ in your program. When
-- your program is run, the I/O will be performed. It isn’t possible to perform I/O from an arbitrary
-- function, unless that function is itself in the @IO@ monad and called at some point, directly or indirectly,
-- from @Main.main@.
--
-- @IO@ is a monad, so @IO@ actions can be combined using either the do-notation or the @>>@ and @>>=@ operations
-- from the @Monad@ class.
data IO a = AbstractIO

fixIO :: (a -> IO a) -> IO a
fixIO = fixIO

-- | File and directory names are values of type @String@, whose precise meaning is operating system dependent.
-- Files can be opened, yielding a handle which can then be used to operate on the contents of that file.
type FilePath = String

-- | Haskell defines operations to read and write characters from and to files, represented by values of type
-- @Handle@. Each value of this type is a /handle/: a record used by the Haskell run-time system to /manage/
-- I/O with file system objects. A handle has at least the following properties:
--
-- - whether it manages input or output or both;
-- - whether it is /open/, /closed/ or /semi-closed/;
-- - whether the object is seekable;
-- - whether buffering is disabled, or enabled on a line or block basis;
-- - a buffer (whose length may be zero).
--
-- Most handles will also have a current I/O position indicating where the next input or output operation
-- will occur. A handle is /readable/ if it manages only input or both input and output; likewise, it is
-- /writable/ if it manages only output or both input and output. A handle is /open/ when first allocated.
-- Once it is closed it can no longer be used for either input or output, though an implementation cannot
-- re-use its storage while references remain to it. Handles are in the 'Show' and 'Eq' classes. The string
-- produced by showing a handle is system dependent; it should include enough information to identify
-- the handle for debugging. A handle is equal according to @==@ only to itself; no attempt is made to
-- compare the internal state of different handles for equality.
data Handle = AbstractHandle

instance Eq Handle

instance Show Handle

-- | A handle managing input from the Haskell program’s standard input channel.
stdin :: Handle
stdin = stdin

-- | A handle managing output to the Haskell program’s standard output channel.
stdout :: Handle
stdout = stdout

-- | A handle managing output to the Haskell program’s standard error channel.
stderr :: Handle
stderr = stderr

-- | @withFile name mode act@ opens a file using 'openFile' and passes the resulting handle to the computation @act@.
-- The handle will be closed on exit from 'withFile', whether by normal termination or
-- by raising an exception. If closing the handle raises an exception, then this exception will be raised by
-- 'withFile' rather than any exception raised by @act@.
withFile :: FilePath -> IOMode -> (Handle -> IO r) -> IO r
withFile = withFile

-- | Computation @openFile file mode@ allocates and returns a new, open handle to manage the file @file@.
-- It manages input if @mode@ is 'ReadMode', output if @mode@ is 'WriteMode' or 'AppendMode', and both input
-- and output if @mode@ is 'ReadWriteMode'.
--
-- If the file does not exist and it is opened for output, it should be created as a new file. If @mode@ is
-- 'WriteMode' and the file already exists, then it should be truncated to zero length. Some operating
-- systems delete empty files, so there is no guarantee that the file will exist following an 'openFile' with
-- mode 'WriteMode' unless it is subsequently written to successfully. The handle is positioned at the end
-- of the file if @mode@ is 'AppendMode', and otherwise at the beginning (in which case its internal position
-- is 0). The initial buffer mode is implementation-dependent.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isAlreadyInUseError' if the file is already open and cannot be reopened;
-- - 'System.IO.Error.isDoesNotExistError' if the file does not exist; or
-- - 'System.IO.Error.isPermissionError' if the user does not have permission to open the file
openFile :: FilePath -> IOMode -> IO Handle
openFile = openFile

-- | See 'System.IO.openFile'
data IOMode
  = ReadMode
  | WriteMode
  | AppendMode
  | ReadWriteMode

instance Enum IOMode

instance Eq IOMode

instance Ord IOMode

instance Read IOMode

instance Show IOMode

instance Ix IOMode

-- | Computation @hClose hdl@ makes handle @hdl@ closed. Before the computation finishes, if @hdl@ is
-- writable its buffer is flushed as for 'hFlush'. Performing 'hClose' on a handle that has already been
-- closed has no effect; doing so is not an error. All other operations on a closed handle will fail. If
-- 'hClose' fails for any reason, any further operations (apart from 'hClose') on the handle will still fail as
-- if @hdl@ had been successfully closed.
hClose :: Handle -> IO ()
hClose = hClose

-- | The 'readFile' function reads a file and returns the contents of the file as a string. The file is read
-- lazily, on demand, as with 'getContents'.
readFile :: FilePath -> IO String
readFile = readFile

-- | The computation @writeFile file str@ function writes the string @str@, to the file @file@.
writeFile :: FilePath -> String -> IO ()
writeFile = writeFile

-- | The computation @appendFile file str@ function appends the string @str@, to the file @file@.
-- Note that 'writeFile' and 'appendFile' write a literal string to a file. To write a value of any printable
-- type, as with 'print', use the 'show' function to convert the value to a string first.
--
-- @
-- main = appendFile "squares" (show [(x,x*x) | x <- [0,0.1..2]])
-- @
appendFile :: FilePath -> String -> IO ()
appendFile = appendFile

-- | For a handle @hdl@ which attached to a physical file, @hFileSize hdl@ returns the size of that file in 8-bit bytes.
hFileSize :: Handle -> IO Integer
hFileSize = hFileSize

-- | @hSetFileSize hdl size@ truncates the physical file with handle @hdl@ to @size@ bytes.
hSetFileSize :: Handle -> Integer -> IO ()
hSetFileSize = hSetFileSize

-- | For a readable handle @hdl@, @hIsEOF hdl@ returns 'True' if no further input can be taken from @hdl@ or for
-- a physical file, if the current I/O position is equal to the length of the file. Otherwise, it returns 'False'.
--
-- NOTE: 'hIsEOF' may block, because it has to attempt to read from the stream to determine whether
-- there is any more data to be read.
hIsEOF :: Handle -> IO Bool
hIsEOF = hIsEOF

-- | The computation 'isEOF' is identical to 'hIsEOF', except that it works only on 'stdin'.
isEOF :: IO Bool
isEOF = isEOF

-- | Three kinds of buffering are supported: line-buffering, block-buffering or no-buffering. These modes
-- have the following effects. For output, items are written out, or /flushed/, from the internal buffer according
-- to the buffer mode:
--
-- - /line-buffering/: the entire output buffer is flushed whenever a newline is output, the buffer over-
--   flows, a 'System.IO.hFlush' is issued, or the handle is closed.
-- - /block-buffering/: the entire buffer is written out whenever it overflows, a 'System.IO.hFlush' is
--   issued, or the handle is closed.
-- - /no-buffering/: output is written immediately, and never stored in the buffer.
--
-- An implementation is free to flush the buffer more frequently, but not less frequently, than specified
-- above. The output buffer is emptied as soon as it has been written out.
--
-- Similarly, input occurs according to the buffer mode for the handle:
--
-- - /line-buffering/: when the buffer for the handle is not empty, the next item is obtained from the
--   buffer; otherwise, when the buffer is empty, characters up to and including the next newline character
--   are read into the buffer. No characters are available until the newline character is available
--   or the buffer is full.
-- - /block-buffering/: when the buffer for the handle becomes empty, the next block of data is read into
--   the buffer.
-- - /no-buffering/: the next input item is read and returned. The 'System.IO.hLookAhead' operation
--   implies that even a no-buffered handle may require a one-character buffer.
--
-- The default buffering mode when a handle is opened is implementation-dependent and may depend on
-- the file system object which is attached to that handle. For most implementations, physical files will
-- normally be block-buffered and terminals will normally be line-buffered.
data BufferMode
  = -- | buffering is disabled if possible.
    NoBuffering
  | -- | line-buffering  should be enabled if possible.
    LineBuffering
  | -- | block-buffering should be enabled if possible. The size of
    -- the buffer is @n@ items if the argument is @Just n@ and is otherwise
    -- implementation-dependent.
    BlockBuffering (Maybe Int)

instance Eq BufferMode

instance Ord BufferMode

instance Read BufferMode

instance Show BufferMode

-- | Computation @hSetBuffering hdl mode@ sets the mode of buffering for handle @hdl@ on subsequent
-- reads and writes.
--
-- If the buffer mode is changed from 'BlockBuffering' or 'LineBuffering' to 'NoBuffering', then
--
-- - if @hdl@ is writable, the buffer is flushed as for 'hFlush';
-- - if @hdl@ is not writable, the contents of the buffer is discarded.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isPermissionError' if the handle has already been used for reading or writing and the implementation
--   does not allow the buffering mode to be changed.
hSetBuffering :: Handle -> BufferMode -> IO ()
hSetBuffering = hSetBuffering

-- | Computation @hGetBuffering hdl@ returns the current buffering mode for @hdl@.
hGetBuffering :: Handle -> IO BufferMode
hGetBuffering = hGetBuffering

-- | The action hFlush hdl causes any items buffered for output in handle hdl to be sent immediately to
-- the operating system.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isFullError' if the device is full;
-- - 'System.IO.Error.isPermissionError' if a system resource limit would be exceeded. It is unspecified whether
--   the characters in the buffer are discarded or retained under these circumstances.
hFlush :: Handle -> IO ()
hFlush = hFlush

-- | Computation @hGetPosn hdl@ returns the current I/O position of @hdl@ as a value of the abstract type
-- 'HandlePosn'.
hGetPosn :: Handle -> IO HandlePosn
hGetPosn = hGetPosn

-- | If a call to @hGetPosn hdl@ returns a position @p@, then computation @hSetPosn p@ sets the position of @hdl@
-- to the position it held at the time of the call to 'hGetPosn'.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isPermissionError' if a system resource limit would be exceeded.
hSetPosn :: HandlePosn -> IO ()
hSetPosn = hSetPosn

data HandlePosn = AbstractHandlePosn

instance Eq HandlePosn

instance Show HandlePosn

-- | Computation @hSeek hdl mode i@ sets the position of handle @hdl@ depending on @mode@. The offset @i@ is
-- given in terms of 8-bit bytes.
--
-- If @hdl@ is block- or line-buffered, then seeking to a position which is not in the current buffer will first
-- cause any items in the output buffer to be written to the device, and then cause the input buffer to be
-- discarded. Some handles may not be seekable (see 'hIsSeekable'), or only support a subset of the
-- possible positioning operations (for instance, it may only be possible to seek to the end of a tape, or to
-- a positive offset from the beginning or current position). It is not possible to set a negative I/O position,
-- or for a physical file, an I/O position beyond the current end-of-file.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isIllegalOperationError' if the Handle is not seekable, or does not support the requested
--   seek mode.
-- - 'System.IO.Error.isPermissionError' if a system resource limit would be exceeded.
hSeek :: Handle -> SeekMode -> Integer -> IO ()
hSeek = hSeek

-- | A mode that determines the effect of @hSeek hdl mode i@.
data SeekMode
  = -- | the position of @hdl@ is set to @i@.
    AbsoluteSeek
  | -- | the position of @hdl@ is set to offset @i@ from the current position.
    RelativeSeek
  | -- | the position of @hdl@ is set to offset @i@ from the end of the file.
    SeekFromEnd

instance Enum SeekMode

instance Eq SeekMode

instance Ord SeekMode

instance Read SeekMode

instance Show SeekMode

instance Ix SeekMode

-- | Computation @hTell hdl@ returns the current position of the handle @hdl@, as the number of bytes from
-- the beginning of the file. The value returned may be subsequently passed to 'hSeek' to reposition the
-- handle to the current position.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isIllegalOperationError' if the Handle is not seekable.
hTell :: Handle -> IO Integer
hTell = hTell

hIsOpen :: Handle -> IO Bool
hIsOpen = hIsOpen

hIsClosed :: Handle -> IO Bool
hIsClosed = hIsClosed

hIsReadable :: Handle -> IO Bool
hIsReadable = hIsReadable

hIsWritable :: Handle -> IO Bool
hIsWritable = hIsWritable

hIsSeekable :: Handle -> IO Bool
hIsSeekable = hIsSeekable

-- | Is the handle connected to a terminal?
hIsTerminalDevice :: Handle -> IO Bool
hIsTerminalDevice = hIsTerminalDevice

-- | Set the echoing status of a handle connected to a terminal.
hSetEcho :: Handle -> Bool -> IO ()
hSetEcho = hSetEcho

-- | Get the echoing status of a handle connected to a terminal.
hGetEcho :: Handle -> IO Bool
hGetEcho = hGetEcho

-- | 'hShow' is in the 'IO' monad, and gives more comprehensive output than the (pure) instance of 'Show' for
-- 'Handle'.
hShow :: Handle -> IO String
hShow = hShow

-- | Computation @hWaitForInput hdl t@ waits until input is available on handle @hdl@. It returns 'True' as
-- soon as input is available on @hdl@, or 'False' if no input is available within @t@ milliseconds. Note that
-- 'hWaitForInput' waits until one or more full characters are available, which means that it needs to do
-- decoding, and hence may fail with a decoding error.
--
-- If @t@ is less than zero, then 'hWaitForInput' waits indefinitely.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file has been reached.
-- - a decoding error, if the input begins with an invalid byte sequence in this Handle’s encoding.
hWaitForInput :: Handle -> Int -> IO Bool
hWaitForInput = hWaitForInput

-- | Computation @hReady hdl@ indicates whether at least one item is available for input from handle @hdl@.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file has been reached.
hReady :: Handle -> IO Bool
hReady = hReady

-- | Computation @hGetChar hdl@ reads a character from the file or channel managed by @hdl@, blocking until
-- a character is available.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file has been reached.
hGetChar :: Handle -> IO Char
hGetChar = hGetChar

-- | Computation @hGetLine hdl@ reads a line from the file or channel managed by @hdl@.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file is encountered when reading the first character of the line.
--
-- If 'hGetLine' encounters end-of-file at any other point while reading in a line, it is treated as a line
-- terminator and the (partial) line is returned.
hGetLine :: Handle -> IO String
hGetLine = hGetLine

-- | Computation 'hLookAhead' returns the next character from the handle without removing it from the
-- input buffer, blocking until a character is available.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file has been reached.
hLookAhead :: Handle -> IO Char
hLookAhead = hLookAhead

-- | Computation @hGetContents hdl@ returns the list of characters corresponding to the unread portion of
-- the channel or file managed by @hdl@, which is put into an intermediate state, /semi-closed/. In this state,
-- @hdl@ is effectively closed, but items are read from @hdl@ on demand and accumulated in a special list
-- returned by @hGetContents hdl@.
--
-- Any operation that fails because a handle is closed, also fails if a handle is semi-closed. The only
-- exception is 'hClose'. A semi-closed handle becomes closed:
--
-- - if 'hClose' is applied to it;
-- - if an I/O error occurs when reading an item from the handle;
-- - or once the entire contents of the handle has been read.
--
-- Once a semi-closed handle becomes closed, the contents of the associated list becomes fixed. The
-- contents of this final list is only partially specified: it will contain at least all the items of the stream
-- that were evaluated prior to the handle becoming closed.
--
-- Any I/O errors encountered while a handle is semi-closed are simply discarded.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isEOFError' if the end of file has been reached.
hGetContents :: Handle -> IO String
hGetContents = hGetContents

-- | Computation @hPutChar hdl ch@ writes the character @ch@ to the file or channel managed by @hdl@.
-- Characters may be buffered if buffering is enabled for @hdl@.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isFullError' if the device is full; or
-- - 'System.IO.Error.isPermissionError' if another system resource limit would be exceeded.
hPutChar :: Handle -> Char -> IO ()
hPutChar = hPutChar

-- | Computation @hPutStr hdl s@ writes the string @s@ to the file or channel managed by @hdl@.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isFullError' if the device is full; or
-- - 'System.IO.Error.isPermissionError' if another system resource limit would be exceeded.
hPutStr :: Handle -> String -> IO ()
hPutStr = hPutStr

-- | The same as 'hPutStr', but adds a newline character.
hPutStrLn :: Handle -> String -> IO ()
hPutStrLn = hPutStrLn

-- | Computation @hPrint hdl t@ writes the string representation of @t@ given by the 'shows' function to the
-- file or channel managed by @hdl@ and appends a newline.
--
-- This operation may fail with:
--
-- - 'System.IO.Error.isFullError' if the device is full; or
-- - 'System.IO.Error.isPermissionError' if another system resource limit would be exceeded
hPrint :: (Show a) => Handle -> a -> IO ()
hPrint = hPrint

-- | The 'interact' function takes a function of type @String->String@ as its argument. The entire input
-- from the standard input device is passed to this function as its argument, and the resulting string is
-- output on the standard output device.
interact :: (String -> String) -> IO ()
interact = interact

-- | Write a character to the standard output device (same as @hPutChar stdout@).
putChar :: Char -> IO ()
putChar = putChar

-- | Write a string to the standard output device (same as @hPutStr stdout@).
putStr :: String -> IO ()
putStr = putStr

-- | The same as 'putStr', but adds a newline character.
putStrLn :: String -> IO ()
putStrLn = putStrLn

-- | The 'print' function outputs a value of any printable type to the standard output device. Printable types
-- are those that are instances of class 'Show'; 'print' converts values to strings for output using the 'show'
-- operation and adds a newline.
--
-- For example, a program to print the first 20 integers and their powers of 2 could be written as:
--
-- @
-- main = print ([(n, 2ˆn) | n <- [0..19]])
-- @
print :: (Show a) => a -> IO ()
print = print

-- | Read a character from the standard input device (same as @hGetChar stdin@).
getChar :: IO Char
getChar = getChar

-- | Read a line from the standard input device (same as @hGetLine stdin@).
getLine :: IO String
getLine = getLine

-- | The 'getContents' operation returns all user input as a single string, which is read lazily as it is needed
-- (same as @hGetContents stdin@).
getContents :: IO String
getContents = getContents

-- | The 'readIO' function is similar to 'read' except that it signals parse failure to the 'IO' monad instead of
-- terminating the program.
readIO :: (Read a) => String -> IO a
readIO = readIO

-- | The 'readLn' function combines 'getLine' and 'readIO'.
readLn :: (Read a) => IO a
readLn = readLn