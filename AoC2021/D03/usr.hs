--Turns 100 into [1,-1,-1]. 1->1, 0->-1
parse = map (map ((+(-1)).(*2).fromEnum.(=='1')))

toNum = foldl aux 0 
  where
    aux acc n = 2*acc + (fromEnum $ n > 0)

star1 ls = (toNum finalNum) * (toNum (map negate finalNum)) 
  where
    finalNum = foldr (zipWith (+)) (repeat 0) ls

filterBit mult ls = (resultingBit, filter ((==resultingBit).head) ls)
  where
    mostCommonBit = foldr ((+).head) 0 ls
    resultingBit = if mostCommonBit == 0 then mult
                    else mult*mostCommonBit `div` (abs mostCommonBit)

star2 ls = (toNum $ aux (1) [] ls) * (toNum $ aux (-1) [] ls)
  where
    aux _ acc [x] = (reverse acc) ++ x
    aux mult acc xs = aux mult (val:acc) (map tail xs')
      where
        (val, xs') = filterBit mult xs


main :: IO ()
main = do
  contents <- getContents
  let dirs = parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 dirs)
  putStrLn $ "Star 2: " ++ (show $ star2 dirs)
