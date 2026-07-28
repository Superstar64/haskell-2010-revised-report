-- |
-- Module: Data.List
module Data.List
  ( -- * Basic functions
    (++),
    head,
    last,
    tail,
    init,
    null,
    length,

    -- * List transformations
    map,
    reverse,
    intersperse,
    intercalate,
    transpose,
    subsequences,
    permutations,

    -- * Reducing lists (folds)
    foldl,
    foldl',
    foldl1,
    foldl1',
    foldr,
    foldr1,

    -- * Special folds
    concat,
    concatMap,
    and,
    or,
    any,
    all,
    sum,
    product,
    maximum,
    minimum,

    -- * Building lists

    -- ** Scans
    scanl,
    scanl1,
    scanr,
    scanr1,

    -- ** Accumulating maps
    mapAccumL,
    mapAccumR,

    -- ** Infinite lists
    iterate,
    repeat,
    replicate,
    cycle,

    -- ** Unfolding
    unfoldr,

    -- * Sublists

    -- ** Extracting sublists
    take,
    drop,
    splitAt,
    takeWhile,
    dropWhile,
    span,
    break,
    stripPrefix,
    group,
    inits,
    tails,

    -- ** Predicates
    isPrefixOf,
    isSuffixOf,
    isInfixOf,

    -- * Searching lists

    -- ** Searching by equality
    elem,
    notElem,
    lookup,

    -- ** Searching with a predicate
    find,
    filter,
    partition,

    -- * Indexing lists

    -- | These functions treat a list @xs@ as a indexed collection, with indices ranging from @0@ to @length xs - 1@.
    (!!),
    elemIndex,
    elemIndices,
    findIndex,
    findIndices,

    -- * Zipping and unzipping lists
    zip,
    zip3,
    zip4,
    zip5,
    zip6,
    zip7,
    zipWith,
    zipWith3,
    zipWith4,
    zipWith5,
    zipWith6,
    zipWith7,
    unzip,
    unzip3,
    unzip4,
    unzip5,
    unzip6,
    unzip7,

    -- * Special lists

    -- ** Functions on strings
    lines,
    words,
    unlines,
    unwords,

    -- ** "Set" operations
    nub,
    delete,
    (\\),
    union,
    intersect,

    -- ** Ordered lists
    sort,
    insert,

    -- * Generalized functions

    -- ** The "By" operations

    -- | By convention, overloaded functions have a non-overloaded counterpart whose name is suffixed with ‘By’.

    -- *** User-supplied equality (replacing an Eq context)

    -- | The predicate is assumed to define an equivalence.
    nubBy,
    deleteBy,
    deleteFirstsBy,
    unionBy,
    intersectBy,
    groupBy,

    -- *** User-supplied comparison (replacing an Ord context)

    -- | The function is assumed to define a total ordering.
    sortBy,
    insertBy,
    maximumBy,
    minimumBy,

    -- ** The "generic" operations

    -- | The prefix ‘generic’ indicates an overloaded function that is a generalized version of a @Prelude@ function.
    genericLength,
    genericTake,
    genericDrop,
    genericSplitAt,
    genericIndex,
    genericReplicate,
  )
where

import Data.Bool
import Data.Char
import Data.Eq
import Data.Int
import Data.Maybe
import Data.Ord
import NumHierarchy

-- | Append two lists, i.e.,
--
-- @
-- [x1, ..., xm] ++ [y1, ..., yn] == [x1, ..., xm, y1, ..., yn]
-- [x1, ..., xm] ++ [y1, ...] == [x1, ..., xm, y1, ...]
-- @
--
-- If the first list is not finite, the result is the first list.
(++) :: [a] -> [a] -> [a]
(++) = (++)

-- | Extract the first element of a list, which must be non-empty.
head :: [a] -> a
head = head

-- | Extract the last element of a list, which must be finite and non-empty.
last :: [a] -> a
last = last

-- | Extract the elements after the head of a list, which must be non-empty.
tail :: [a] -> [a]
tail = tail

-- | Return all the elements of a list except the last one. The list must be non-empty.
init :: [a] -> [a]
init = init

-- | Test whether a list is empty.
null :: [a] -> Bool
null = null

-- | O(n). 'length' returns the length of a finite list as an 'Int'. It is an instance of the more general
-- 'Data.List.genericLength', the result type of which may be any kind of number.
length :: [a] -> Int
length = length

-- | @map f xs@ is the list obtained by applying @f@ to each element of @xs@, i.e.,
--
-- @
-- map f [x1, x2, ..., xn] == [f x1, f x2, ..., f xn]
-- map f [x1, x2, ...] == [f x1, f x2, ...]
-- @
map :: (a -> b) -> [a] -> [b]
map = map

-- | @reverse xs@ returns the elements of @xs@ in reverse order. @xs@ must be finite.
reverse :: [a] -> [a]
reverse = reverse

-- | The 'intersperse' function takes an element and a list and ‘intersperses’ that element between the
-- elements of the list. For example,
--
-- @
-- intersperse ’,’ "abcde" == "a,b,c,d,e"
-- @
intersperse :: a -> [a] -> [a]
intersperse = intersperse

-- | @intercalate xs xss@ is equivalent to @(concat (intersperse xs xss))@. It inserts the list @xs@ in
-- between the lists in @xss@ and concatenates the result.
intercalate :: [a] -> [[a]] -> [a]
intercalate = intercalate

-- | The 'transpose' function transposes the rows and columns of its argument. For example,
--
-- @
--transpose [[1,2,3],[4,5,6]] == [[1,4],[2,5],[3,6]]
-- @
transpose :: [[a]] -> [[a]]
transpose = transpose

-- | The 'subsequences' function returns the list of all subsequences of the argument.
--
-- @
--subsequences "abc" == ["","a","b","ab","c","ac","bc","abc"]
-- @
subsequences :: [a] -> [[a]]
subsequences = subsequences

-- | The 'permutations' function returns the list of all permutations of the argument.
--
-- @
-- permutations "abc" == ["abc","bac","cba","bca","cab","acb"]
-- @
permutations :: [a] -> [[a]]
permutations = permutations

-- | 'foldl', applied to a binary operator, a starting value (typically the left-identity of the operator), and a
-- list, reduces the list using the binary operator, from left to right:
--
-- @
-- foldl f z [x1, x2, ..., xn] == (...((z ‘f‘ x1) ‘f‘ x2) ‘f‘...) ‘f‘ xn
-- @
--
-- The list must be finite.
foldl :: (a -> b -> a) -> a -> [b] -> a
foldl = foldl

-- | A strict version of 'foldl'.
foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' = foldl'

-- | 'foldl1' is a variant of 'foldl' that has no starting value argument, and thus must be applied to non-
-- empty lists.
foldl1 :: (a -> a -> a) -> [a] -> a
foldl1 = foldl1

-- | A strict version of 'foldl1'
foldl1' :: (a -> a -> a) -> [a] -> a
foldl1' = foldl1'

-- | 'foldr', applied to a binary operator, a starting value (typically the right-identity of the operator), and a
-- list, reduces the list using the binary operator, from right to left:
--
-- @
-- foldr f z [x1, x2, ..., xn] == x1 ‘f‘ (x2 ‘f‘ ... (xn ‘f‘ z)...)
-- @
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr = foldr

-- | 'foldr1' is a variant of 'foldr' that has no starting value argument, and thus must be applied to non-
-- empty lists.
foldr1 :: (a -> a -> a) -> [a] -> a
foldr1 = foldr1

-- | Concatenate a list of lists.
concat :: [[a]] -> [a]
concat = concat

-- | Map a function over a list and concatenate the results.
concatMap :: (a -> [b]) -> [a] -> [b]
concatMap = concatMap

-- | 'and' returns the conjunction of a Boolean list. For the result to be 'True', the list must be finite; 'False',
-- however, results from a 'False' value at a finite index of a finite or infinite list.
and :: [Bool] -> Bool
and = and

-- | 'or' returns the disjunction of a Boolean list. For the result to be 'False', the list must be finite; 'True',
-- however, results from a 'True' value at a finite index of a finite or infinite list.
or :: [Bool] -> Bool
or = or

-- | Applied to a predicate and a list, 'any' determines if any element of the list satisfies the predicate. For the
-- result to be 'False', the list must be finite; 'True', however, results from a 'True' value for the predicate
-- applied to an element at a finite index of a finite or infinite list.
any :: (a -> Bool) -> [a] -> Bool
any = any

-- | Applied to a predicate and a list, 'all' determines if all elements of the list satisfy the predicate. For the
-- result to be 'True', the list must be finite; 'False', however, results from a 'False' value for the predicate
-- applied to an element at a finite index of a finite or infinite list.
all :: (a -> Bool) -> [a] -> Bool
all = all

-- | The 'sum' function computes the sum of a finite list of numbers.
sum :: (Num a) => [a] -> a
sum = sum

-- | The 'product' function computes the product of a finite list of numbers
product :: (Num a) => [a] -> a
product = product

-- | 'maximum' returns the maximum value from a list, which must be non-empty, finite, and of an ordered
-- type. It is a special case of 'maximumBy', which allows the programmer to supply their own comparison
-- function.
maximum :: (Ord a) => [a] -> a
maximum = maximum

-- | 'minimum' returns the minimum value from a list, which must be non-empty, finite, and of an ordered
-- type. It is a special case of 'minimumBy', which allows the programmer to supply their own comparison
-- function.
minimum :: (Ord a) => [a] -> a
minimum = minimum

-- | 'scanl' is similar to 'foldl', but returns a list of successive reduced values from the left:
--
-- @
-- scanl f z [x1, x2, ...] == [z, z ‘f‘ x1, (z ‘f‘ x1) ‘f‘ x2, ...]
-- @
--
-- Note that
--
-- @
-- last (scanl f z xs) == foldl f z xs.
-- @
scanl :: (a -> b -> a) -> a -> [b] -> [a]
scanl = scanl

-- | 'scanl1' is a variant of 'scanl' that has no starting value argument:
--
-- @
-- scanl1 f [x1, x2, ...] == [x1, x1 ‘f‘ x2, ...]
-- @
scanl1 :: (a -> a -> a) -> [a] -> [a]
scanl1 = scanl1

-- | 'scanr' is the right-to-left dual of 'scanl'. Note that
--
-- @
-- head (scanr f z xs) == foldr f z xs.
-- @
scanr :: (a -> b -> b) -> b -> [a] -> [b]
scanr = scanr

-- | 'scanr1' is a variant of 'scanr' that has no starting value argument.
scanr1 :: (a -> a -> a) -> [a] -> [a]
scanr1 = scanr1

-- | The 'mapAccumL' function behaves like a combination of 'map' and 'foldl'; it applies a function to each
-- element of a list, passing an accumulating parameter from left to right, and returning a final value of
-- this accumulator together with the new list.
mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
mapAccumL = mapAccumL

-- | The 'mapAccumR' function behaves like a combination of 'map' and 'foldr'; it applies a function to each
-- element of a list, passing an accumulating parameter from right to left, and returning a final value of
-- this accumulator together with the new list.
mapAccumR :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
mapAccumR = mapAccumR

-- | @iterate f x@ returns an infinite list of repeated applications of @f@ to @x@:
--
-- @
-- iterate f x == [x, f x, f (f x), ...]
-- @
iterate :: (a -> a) -> a -> [a]
iterate = iterate

-- | @repeat x@ is an infinite list, with @x@ the value of every element.
repeat :: a -> [a]
repeat = repeat

-- | @replicate n x@ is a list of length @n@ with @x@ the value of every element. It is an instance of the more
-- general @Data.List.genericReplicate@, in which @n@ may be of any integral type.
replicate :: Int -> a -> [a]
replicate = replicate

-- | 'cycle' ties a finite list into a circular one, or equivalently, the infinite repetition of the original list. It is
-- the identity on infinite lists.
cycle :: [a] -> [a]
cycle = cycle

-- | The 'unfoldr' function is a ‘dual’ to 'foldr': while 'foldr' reduces a list to a summary value, 'unfoldr'
-- builds a list from a seed value. The function takes the element and returns 'Nothing' if it is done
-- producing the list or returns @Just (a,b)@, in which case, @a@ is a prepended to the list and @b@ is used as
-- the next element in a recursive call. For example,
--
-- @
-- iterate f == unfoldr (\x -> Just (x, f x))
-- @
--
-- In some cases, 'unfoldr' can undo a 'foldr' operation:
--
-- @
-- unfoldr f’ (foldr f z xs) == xs
-- @
--
-- if the following holds:
--
-- @
-- f’ (f x y) = Just (x,y)
-- f’ z = Nothing
-- @
--
-- A simple use of unfoldr:
--
-- @
-- unfoldr (\b -> if b == 0 then Nothing else Just (b, b-1)) 10
--   [10,9,8,7,6,5,4,3,2,1]
-- @
unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
unfoldr = unfoldr

-- | @take n@, applied to a list @xs@, returns the prefix of @xs@ of length @n@, or @xs@ itself if @n > length xs@:
--
-- @
-- take 5 "Hello World!" == "Hello"
-- take 3 [1,2,3,4,5] == [1,2,3]
-- take 3 [1,2] == [1,2]
-- take 3 [] == []
-- take (-1) [1,2] == []
-- take 0 [1,2] == []
-- @
--
-- It is an instance of the more general 'Data.List.genericTake', in which @n@ may be of any integral
-- type.
take :: Int -> [a] -> [a]
take = take

-- | @drop n xs@ returns the suffix of @xs@ after the first @n@ elements, or @[]@ if @n > length xs@:
--
-- @
-- drop 6 "Hello World!" == "World!"
-- drop 3 [1,2,3,4,5] == [4,5]
-- drop 3 [1,2] == []
-- drop 3 [] == []
-- drop (-1) [1,2] == [1,2]
-- drop 0 [1,2] == [1,2]
-- @
--
-- It is an instance of the more general 'Data.List.genericDrop', in which @n@ may be of any integral
-- type.
drop :: Int -> [a] -> [a]
drop = drop

-- | @splitAt n xs@ returns a tuple where first element is @xs@ prefix of length @n@ and second element is the
-- remainder of the list:
--
-- @
-- splitAt 6 "Hello World!" == ("Hello ","World!")
-- splitAt 3 [1,2,3,4,5] == ([1,2,3],[4,5])
-- splitAt 1 [1,2,3] == ([1],[2,3])
-- splitAt 3 [1,2,3] == ([1,2,3],[])
-- splitAt 4 [1,2,3] == ([1,2,3],[])
-- splitAt 0 [1,2,3] == ([],[1,2,3])
-- splitAt (-1) [1,2,3] == ([],[1,2,3])
-- @
--
-- It is equivalent to @(take n xs, drop n xs)@. 'splitAt' is an instance of the more general
-- 'Data.List.genericSplitAt', in which @n@ may be of any integral type.
splitAt :: Int -> [a] -> ([a], [a])
splitAt = splitAt

-- | 'takeWhile', applied to a predicate @p@ and a list @xs@, returns the longest prefix (possibly empty) of @xs@ of
-- elements that satisfy @p@:
--
-- @
-- takeWhile (< 3) [1,2,3,4,1,2,3,4] == [1,2]
-- takeWhile (< 9) [1,2,3] == [1,2,3]
-- takeWhile (< 0) [1,2,3] == []
-- @
takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile = takeWhile

-- | @dropWhile p xs@ returns the suffix remaining after @takeWhile p xs@:
--
-- @
-- dropWhile (< 3) [1,2,3,4,5,1,2,3] == [3,4,5,1,2,3]
-- dropWhile (< 9) [1,2,3] == []
-- dropWhile (< 0) [1,2,3] == [1,2,3]
-- @
dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile = dropWhile


-- | 'span', applied to a predicate @p@ and a list @xs@, returns a tuple where first element is longest prefix (possibly
-- empty) of @xs@ of elements that satisfy @p@ and second element is the remainder of the list:
--
-- @
-- span (< 3) [1,2,3,4,1,2,3,4] == ([1,2],[3,4,1,2,3,4])
-- span (< 9) [1,2,3] == ([1,2,3],[])
-- span (< 0) [1,2,3] == ([],[1,2,3])
-- @
--
-- @span p xs@ is equivalent to @(takeWhile p xs, dropWhile p xs)@
span :: (a -> Bool) -> [a] -> ([a], [a])
span = span

-- | 'break', applied to a predicate @p@ and a list @xs@, returns a tuple where first element is longest prefix
-- (possibly empty) of @xs@ of elements that do not satisfy @p@ and second element is the remainder of the list:
--
-- @
-- break (> 3) [1,2,3,4,1,2,3,4] == ([1,2,3],[4,1,2,3,4])
-- break (< 9) [1,2,3] == ([],[1,2,3])
-- break (> 9) [1,2,3] == ([1,2,3],[])
-- @
--
-- @break p@ is equivalent to @span (not . p)@.
break :: (a -> Bool) -> [a] -> ([a], [a])
break = break

-- | The 'stripPrefix' function drops the given prefix from a list. It returns 'Nothing' if the list did not
-- start with the prefix given, or 'Just' the list after the prefix, if it does.
--
-- @
-- stripPrefix "foo" "foobar" == Just "bar"
-- stripPrefix "foo" "foo" == Just ""
-- stripPrefix "foo" "barfoo" == Nothing
-- stripPrefix "foo" "barfoobaz" == Nothing
-- @
stripPrefix :: (Eq a) => [a] -> [a] -> Maybe [a]
stripPrefix = stripPrefix

-- | The 'group' function takes a list and returns a list of lists such that the concatenation of the result is
-- equal to the argument. Moreover, each sublist in the result contains only equal elements. For example,
--
-- @
-- group "Mississippi" = ["M","i","ss","i","ss","i","pp","i"]
-- @
--
-- It is a special case of 'groupBy', which allows the programmer to supply their own equality test.
group :: (Eq a) => [a] -> [[a]]
group = group

-- | The 'inits' function returns all initial segments of the argument, shortest first. For example,
--
-- @
-- inits "abc" == ["","a","ab","abc"]
-- @
inits :: [a] -> [[a]]
inits = inits

-- | The tails function returns all final segments of the argument, longest first. For example,
--
-- @
-- tails "abc" == ["abc", "bc", "c",""]
-- @
tails :: [a] -> [[a]]
tails = tails

-- | The 'isPrefixOf' function takes two lists and returns 'True' iff the first list is a prefix of the second.
isPrefixOf :: (Eq a) => [a] -> [a] -> Bool
isPrefixOf = isPrefixOf

-- | The 'isSuffixOf' function takes two lists and returns 'True' iff the first list is a suffix of the second.
-- Both lists must be finite.
isSuffixOf :: (Eq a) => [a] -> [a] -> Bool
isSuffixOf = isSuffixOf

-- | The 'isInfixOf' function takes two lists and returns 'True' iff the first list is contained, wholly and
-- intact, anywhere within the second.
--
-- Example:
--
-- @
-- isInfixOf "Haskell" "I really like Haskell." == True
-- isInfixOf "Ial" "I really like Haskell." == False
-- @
isInfixOf :: (Eq a) => [a] -> [a] -> Bool
isInfixOf = isInfixOf

-- | 'elem' is the list membership predicate, usually written in infix form, e.g., @x ‘elem‘ xs@. For the result
-- to be 'False', the list must be finite; 'True', however, results from an element equal to @x@ found at a finite
-- index of a finite or infinite list.
elem :: (Eq a) => a -> [a] -> Bool
elem = elem

-- | 'notElem' is the negation of 'elem'.
notElem :: (Eq a) => a -> [a] -> Bool
notElem = notElem

-- | @lookup key assocs@ looks up a key in an association list.
lookup :: (Eq a) => a -> [(a, b)] -> Maybe b
lookup = lookup

-- | The 'find' function takes a predicate and a list and returns the first element in the list matching the
-- predicate, or 'Nothing' if there is no such element.
find :: (a -> Bool) -> [a] -> Maybe a
find = find

-- | 'filter', applied to a predicate and a list, returns the list of those elements that satisfy the predicate;
-- i.e.,
--
-- @
-- filter p xs = [ x | x <- xs, p x]
-- @
filter :: (a -> Bool) -> [a] -> [a]
filter = filter

-- | The 'partition' function takes a predicate a list and returns the pair of lists of elements which do and
-- do not satisfy the predicate, respectively; i.e.,
--
-- @
-- partition p xs == (filter p xs, filter (not . p) xs)
-- @
partition :: (a -> Bool) -> [a] -> ([a], [a])
partition = partition

-- | List index (subscript) operator, starting from 0. It is an instance of the more general
-- 'Data.List.genericIndex', which takes an index of any integral type.
(!!) :: [a] -> Int -> a
(!!) = (!!)

-- | The 'elemIndex' function returns the index of the first element in the given list which is equal (by '==')
-- to the query element, or 'Nothing' if there is no such element.
elemIndex :: (Eq a) => a -> [a] -> Maybe Int
elemIndex = elemIndex

-- | The 'elemIndices' function extends 'elemIndex', by returning the indices of all elements equal to the
-- query element, in ascending order.
elemIndices :: (Eq a) => a -> [a] -> [Int]
elemIndices = elemIndices

-- | The 'findIndex' function takes a predicate and a list and returns the index of the first element in the
-- list satisfying the predicate, or 'Nothing' if there is no such element.
findIndex :: (a -> Bool) -> [a] -> Maybe Int
findIndex = findIndex

-- | The 'findIndices' function extends 'findIndex', by returning the indices of all elements satisfying
-- the predicate, in ascending order.
findIndices :: (a -> Bool) -> [a] -> [Int]
findIndices = findIndices

-- | 'zip' takes two lists and returns a list of corresponding pairs. If one input list is short, excess elements
-- of the longer list are discarded.
zip :: [a] -> [b] -> [(a, b)]
zip = zip

-- | 'zip3' takes three lists and returns a list of triples, analogous to 'zip'.
zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
zip3 = zip3

-- | The 'zip4' function takes four lists and returns a list of quadruples, analogous to 'zip'.
zip4 :: [a] -> [b] -> [c] -> [d] -> [(a, b, c, d)]
zip4 = zip4

-- | The 'zip5' function takes five lists and returns a list of five-tuples, analogous to 'zip'.
zip5 :: [a] -> [b] -> [c] -> [d] -> [e] -> [(a, b, c, d, e)]
zip5 = zip5

-- | The 'zip6' function takes six lists and returns a list of six-tuples, analogous to 'zip'.
zip6 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [(a, b, c, d, e, f)]
zip6 = zip6

-- | The 'zip7' function takes seven lists and returns a list of seven-tuples, analogous to 'zip'.
zip7 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [(a, b, c, d, e, f, g)]
zip7 = zip7

-- | 'zipWith' generalises 'zip' by zipping with the function given as the first argument, instead of a tupling
-- function. For example, @zipWith (+)@ is applied to two lists to produce the list of corresponding sums.
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith = zipWith

-- | The 'zipWith3' function takes a function which combines three elements, as well as three lists and
-- returns a list of their point-wise combination, analogous to 'zipWith'.
zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
zipWith3 = zipWith3

-- | The 'zipWith4' function takes a function which combines four elements, as well as four lists and returns
-- a list of their point-wise combination, analogous to 'zipWith'.
zipWith4 :: (a -> b -> c -> d -> e) -> [a] -> [b] -> [c] -> [d] -> [e]
zipWith4 = zipWith4

-- | The 'zipWith5' function takes a function which combines five elements, as well as five lists and returns
-- a list of their point-wise combination, analogous to 'zipWith'.
zipWith5 :: (a -> b -> c -> d -> e -> f) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f]
zipWith5 = zipWith5

-- | The 'zipWith6' function takes a function which combines six elements, as well as six lists and returns
-- a list of their point-wise combination, analogous to 'zipWith'.
zipWith6 :: (a -> b -> c -> d -> e -> f -> g) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g]
zipWith6 = zipWith6

-- | The 'zipWith7' function takes a function which combines seven elements, as well as seven lists and
-- returns a list of their point-wise combination, analogous to 'zipWith'.
zipWith7 :: (a -> b -> c -> d -> e -> f -> g -> h) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [h]
zipWith7 = zipWith7

-- | 'unzip' transforms a list of pairs into a list of first components and a list of second components.
unzip :: [(a, b)] -> ([a], [b])
unzip = unzip

-- | The 'unzip3' function takes a list of triples and returns three lists, analogous to 'unzip'.
unzip3 :: [(a, b, c)] -> ([a], [b], [c])
unzip3 = unzip3

-- | The 'unzip4' function takes a list of quadruples and returns four lists, analogous to 'unzip'.
unzip4 :: [(a, b, c, d)] -> ([a], [b], [c], [d])
unzip4 = unzip4

-- | The 'unzip5' function takes a list of five-tuples and returns five lists, analogous to 'unzip'.
unzip5 :: [(a, b, c, d, e)] -> ([a], [b], [c], [d], [e])
unzip5 = unzip5

-- | The 'unzip6' function takes a list of six-tuples and returns six lists, analogous to 'unzip'.
unzip6 :: [(a, b, c, d, e, f)] -> ([a], [b], [c], [d], [e], [f])
unzip6 = unzip6

-- | The 'unzip7' function takes a list of seven-tuples and returns seven lists, analogous to 'unzip'.
unzip7 :: [(a, b, c, d, e, f, g)] -> ([a], [b], [c], [d], [e], [f], [g])
unzip7 = unzip7

-- | 'lines' breaks a string up into a list of strings at newline characters. The resulting strings do not contain
-- newlines.
lines :: String -> [String]
lines = lines

-- | 'words' breaks a string up into a list of words, which were delimited by white space.
words :: String -> [String]
words = words

-- | 'unlines' is an inverse operation to 'lines'. It joins lines, after appending a terminating newline to
-- each.
unlines :: [String] -> String
unlines = unlines

-- | 'unwords' is an inverse operation to 'words'. It joins words with separating spaces.
unwords :: [String] -> String
unwords = unwords

-- | O(nˆ2). The 'nub' function removes duplicate elements from a list. In particular, it keeps only the first
-- occurrence of each element. (The name @nub@ means ‘essence’.) It is a special case of 'nubBy', which
-- allows the programmer to supply their own equality test.
nub :: Eq a => [a] -> [a]
nub = nub

-- | @delete x@ removes the first occurrence of @x@ from its list argument. For example,
--
-- @
-- delete ’a’ "banana" == "bnana"
-- @
--
-- It is a special case of 'deleteBy', which allows the programmer to supply their own equality test.
delete :: Eq a => a -> [a] -> [a]
delete = delete

-- | The '\\' function is list difference ((non-associative). In the result of @xs \\\\ ys@, the first occurrence of
-- each element of @ys@ in turn (if any) has been removed from @xs@. Thus
--
-- @
-- (xs ++ ys) \\\\ xs == ys.
-- @
--
-- It is a special case of 'deleteFirstsBy', which allows the programmer to supply their own equality
-- test.
(\\) :: Eq a => [a] -> [a] -> [a]
(\\) = (\\)

-- | The 'union' function returns the list union of the two lists. For example,
--
-- @
-- "dog" ‘union‘ "cow" == "dogcw"
-- @
--
-- Duplicates, and elements of the first list, are removed from the the second list, but if the first list
-- contains duplicates, so will the result. It is a special case of 'unionBy', which allows the programmer
-- to supply their own equality test.
union :: Eq a => [a] -> [a] -> [a]
union = union

-- | The 'intersect' function takes the list intersection of two lists. For example,
--
-- @
-- [1,2,3,4] ‘intersect‘ [2,4,6,8] == [2,4]
-- @
--
-- If the first list contains duplicates, so will the result.
--
-- @
-- [1,2,2,3,4] ‘intersect‘ [6,4,4,2] == [2,2,4]
-- @
--
-- It is a special case of 'intersectBy', which allows the programmer to supply their own equality test.
intersect :: Eq a => [a] -> [a] -> [a]
intersect = intersect

-- | The 'sort' function implements a stable sorting algorithm. It is a special case of 'sortBy', which allows
-- the programmer to supply their own comparison function.
sort :: Ord a => [a] -> [a]
sort = sort

-- | The 'insert' function takes an element and a list and inserts the element into the list at the last position
-- where it is still less than or equal to the next element. In particular, if the list is sorted before the call,
-- the result will also be sorted. It is a special case of 'insertBy', which allows the programmer to supply
-- their own comparison function.
insert :: Ord a => a -> [a] -> [a]
insert = insert

-- | The 'nubBy' function behaves just like 'nub', except it uses a user-supplied equality predicate instead of
-- the overloaded '==' function.
nubBy :: (a -> a -> Bool) -> [a] -> [a]
nubBy = nubBy

-- | The 'deleteBy' function behaves like 'delete', but takes a user-supplied equality predicate.
deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
deleteBy = deleteBy

-- | The 'deleteFirstsBy' function takes a predicate and two lists and returns the first list with the first
-- occurrence of each element of the second list removed.
deleteFirstsBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
deleteFirstsBy = deleteFirstsBy

-- | The 'unionBy' function is the non-overloaded version of 'union'.
unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
unionBy = unionBy

-- | The 'intersectBy' function is the non-overloaded version of 'intersect'.
intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
intersectBy = intersectBy

-- | The 'groupBy' function is the non-overloaded version of 'group'.
groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy = groupBy

-- | The 'sortBy' function is the non-overloaded version of 'sort'.
sortBy :: (a -> a -> Ordering) -> [a] -> [a]
sortBy = sortBy

-- | The non-overloaded version of 'insert'.
insertBy :: (a -> a -> Ordering) -> a -> [a] -> [a]
insertBy = insertBy

-- | The 'maximumBy' function takes a comparison function and a list and returns the greatest element of the
-- list by the comparison function. The list must be finite and non-empty.
maximumBy :: (a -> a -> Ordering) -> [a] -> a
maximumBy = maximumBy

-- | The 'minimumBy' function takes a comparison function and a list and returns the least element of the
-- list by the comparison function. The list must be finite and non-empty.
minimumBy :: (a -> a -> Ordering) -> [a] -> a
minimumBy = minimumBy

-- | The 'genericLength' function is an overloaded version of 'length'. In particular, instead of returning
-- an 'Int', it returns any type which is an instance of 'Num'. It is, however, less efficient than 'length'.
genericLength :: Num i => [b] -> i
genericLength = genericLength

-- | The 'genericTake' function is an overloaded version of 'take', which accepts any 'Integral' value as
-- the number of elements to take.
genericTake :: Integral i => i -> [a] -> [a]
genericTake = genericTake

-- | The 'genericDrop' function is an overloaded version of 'drop', which accepts any 'Integral' value as
-- the number of elements to drop.
genericDrop :: Integral i => i -> [a] -> [a]
genericDrop = genericDrop

-- | The 'genericSplitAt' function is an overloaded version of 'splitAt', which accepts any 'Integral'
-- value as the position at which to split.
genericSplitAt :: Integral i => i -> [b] -> ([b], [b])
genericSplitAt = genericSplitAt

-- | The 'genericIndex' function is an overloaded version of '!!', which accepts any 'Integral' value as
-- the index.
genericIndex :: Integral a => [b] -> a -> b
genericIndex = genericIndex

-- | The 'genericReplicate' function is an overloaded version of 'replicate', which accepts any
-- 'Integral' value as the number of repetitions to make.
genericReplicate :: Integral i => i -> a -> [a]
genericReplicate = genericReplicate