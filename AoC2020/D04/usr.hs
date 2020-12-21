import qualified Data.Map as Map

parse :: [String] -> String -> [String]
parse (x:xs) acc
  | x == "" = acc : parse xs ""
  | otherwise = parse xs (acc ++ ' ':x)
parse _ acc = [acc]

hasFields :: [String] -> Bool
hasFields ls = fields <= 0
  where
    ls' = map (take 3) ls
    fields = if "cid" `elem` ls' then 8 - length ls' else 7 - length ls'

genMap :: [String] -> Map.Map String String
genMap ss = Map.fromList (map aux ss)
  where aux s = (take 3 s, drop 4 s)

digitHex c = '0' <= c && c <= '9' || 'a' <= c && c <= 'f'
digit c = '0' <= c && c <= '9'

validate :: Map.Map String String -> Bool
validate m = byr && iyr && eyr && hgt && hcl && ecl && pid
  where
    byr = case "byr" `Map.lookup` m of
            Nothing -> False
            Just a -> 1920 <= i && i <= 2002
              where i = (read a) :: Int
    iyr = case "iyr" `Map.lookup` m of
            Nothing -> False
            Just a -> 2010 <= i && i <= 2020
              where i = (read a) :: Int
    eyr = case "eyr" `Map.lookup` m of
            Nothing -> False
            Just a -> 2020 <= i && i <= 2030
              where i = (read a) :: Int
    hcl = case "hcl" `Map.lookup` m of
            Nothing -> False
            Just a -> head a == '#' && all digitHex (tail a)
    ecl = case "ecl" `Map.lookup` m of
            Nothing -> False
            Just a -> a `elem` ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
              where i = (read a) :: Int
    pid = case "pid" `Map.lookup` m of
            Nothing -> False
            Just a -> length a == 9 && all digit a
    hgt = case "hgt" `Map.lookup` m of
            Nothing -> False
            Just a -> (length a > 2) && ((lst == "cm" && 150 <= i && i <= 193) || (lst == "in" && 59 <= i && i <= 76))
              where 
                lst = [last $ init a, last a]
                i = ((read . init . init) a) :: Int

star1 = length . filter hasFields
star2 = length . filter (validate . genMap)

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  let p = map words $ parse ls ""
  putStrLn $ "Star 1: " ++ (show $ star1 p)
  putStrLn $ "Star 2: " ++ (show $ star2 p)
