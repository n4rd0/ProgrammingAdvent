import Data.Char (ord, chr, isSeparator)

mulAcc :: [(Int, Int)] -> Int
mulAcc = foldl (\acc (a,m) -> acc + a * m) 0

--Generate the respective infinite list with the multipliers
--e.g. [1 0 -1 0 1 ..], [1 1 1 0 0 0 -1 -1 -1 0 0 0 1 1 1 ..]
genMultipliers :: Int -> [Int]
genMultipliers c = cycle $ {-foldr (++) []-} concat $ map (replicate c) [1, 0, -1, 0]

--Compute next phase
nextPhase :: [Int] -> Int -> [Int]
nextPhase l@(x:xs) c = num : nextPhase xs (c+1)
    where
        num = (abs val) `mod` 10
        val = mulAcc $ filter (\(_,m) -> m /= 0) $ zip l (genMultipliers c)
nextPhase [] _ = []

--Compute next phase, 2nd star
nextPhase2 :: [Int] -> Int -> [Int]
nextPhase2 (x:xs) acc = nxtacc : nextPhase2 xs nxtacc
    where
        nxtacc = (x+acc) `mod` 10
nextPhase2 [] _ = []

--Turn a list into the corresponding number
toNum :: [Int] -> Int
toNum = foldl1 (\acc n -> 10 * acc + n)

--Not only evaluates but also reverses the list
seqRecRev :: [a] -> [a] -> [a]
seqRecRev (x:xs) acc = x `seq` (seqRecRev xs (x:acc))
seqRecRev [] acc = acc


star1 :: [Int] -> String
star1 ns = concatMap show $ take 8 calc
    where
        calc = last $ take 101 $ iterate (\ph -> nextPhase ph 1) ns

star2 :: [Int] -> String
star2 ns = concatMap show $ take 8 $ seqRecRev calc []
    where
        offset = toNum $ take 7 ns
        len = length ns
        m = offset `mod` len
        ls = reverse $ drop m $ take (10000 * len - len * (offset `div` len)) $ cycle ns
        calc = last $ take 101 $ iterate (\ph -> nextPhase2 ph 0) ls


main :: IO ()
main = do
    input <- getContents
    let relevant = takeWhile (/='\n') $ filter (not . isSeparator) input
    let nums = map ((+) (-(ord '0')) . ord) relevant --Turns the chars into the respective numbers. "12" -> [1,2]

    putStrLn $ star1 nums
    putStrLn $ star2 nums
