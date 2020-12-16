import Data.List.Split (splitOn)
import Data.List (transpose, isPrefixOf)

type Restriction = (String, (Int,Int), (Int,Int))

csvToIntList :: String -> [Int]
csvToIntList = map read . splitOn ","

toRestriction :: String -> Restriction
toRestriction s = (name, (read a, read b), (read c, read d))
    where
        name = takeWhile (/=':') s
        _:s' = dropWhile (/=':') s
        [first, second, third] = splitOn "-" s'
        a = first
        b = takeWhile (/=' ') second
        _:c = dropWhile (/='r') second
        d = third

followsRestriction :: Restriction -> Int -> Bool
followsRestriction (_, (la,lb),(ua,ub)) i = (la <= i && i <= lb) || (ua <= i && i <= ub)

followsOneRestriction :: [Restriction] -> Int -> Bool
followsOneRestriction restrictions num = or $ zipWith followsRestriction restrictions (repeat num)

allRulesThatApply :: [Restriction] -> [Int] -> [Restriction]
allRulesThatApply (r:rs) g = if all (followsRestriction r) g then r : allRulesThatApply rs g else allRulesThatApply rs g
allRulesThatApply _ _ = []

possibleRules :: [Restriction] -> [[Int]] -> [[Restriction]]
possibleRules rs gs = foldr ((:).(allRulesThatApply rs)) [] gs

removeIfUnique :: [[Restriction]] -> [[Restriction]] -> [[Restriction]]
removeIfUnique (l:ls) complete = if length l == 1 && changed
    then removeIfUnique newLs newLs
    else removeIfUnique ls complete
    where
        changed = newLs /= complete
        newLs = map aux complete
        aux l' = if length l' == 1 then l' else filter (/= (head l)) l'
removeIfUnique [] complete = complete

getIndices :: (String -> Bool) -> Int -> [Restriction] -> [Int]
getIndices f c ((name,_,_):xs) = if f name then c : newCall else newCall
    where newCall = getIndices f (c+1) xs
getIndices _ _ _ = []

star1 restrictions = sum . filter (not . followsOneRestriction restrictions) . foldr1 (++)

--In my sample there was no need for branching, so it isn't implemented
star2 restrictions otherTickets myTicket = (product . map (myTicket !!) . indices) check
    where
        indices = getIndices (isPrefixOf "departure") 0
        check = if all ((==1).length) simpleFilter
            then map head simpleFilter
            else error "Branching is needed but not implemented. Maybe the required fields are unique, try setting the if to False"
        simpleFilter = removeIfUnique possible possible
        possible = possibleRules restrictions groupByRestriction
        groupByRestriction = transpose validTickets
        validTickets = filter allFollow otherTickets
        allFollow ticket = all (followsOneRestriction restrictions) ticket

main :: IO ()
main = do
  contents <- getContents
  let ls = (map lines . splitOn "\n\n") contents
  let restrictions = map toRestriction (ls !! 0)
  let myTicket = csvToIntList $ ls !! 1 !! 1
  let otherTickets = map csvToIntList $ tail (ls !! 2)

  putStrLn $ "Star 1: " ++ (show $ star1 restrictions otherTickets)
  putStrLn $ "Star 2: " ++ (show $ star2 restrictions otherTickets myTicket)
