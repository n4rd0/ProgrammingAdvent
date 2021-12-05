move1 [hor,depth] (dir,amount)
  | dir == "forward" = [hor+amount,depth]
  | dir == "down" = [hor,depth+amount]
  | dir == "up" = [hor,depth-amount]

move2 [hor,depth,aim] (dir,amount)
  | dir == "forward" = [hor+amount,depth+aim*amount,aim]
  | dir == "down" = [hor,depth,aim+amount]
  | dir == "up" = [hor,depth,aim-amount]

star move list = product . take 2 . foldl move list

star1 = star move1 [0,0]
star2 = star move2 [0,0,0]

main :: IO ()
main = do
  contents <- getContents
  let dirs = map ((\[x,y] -> (x,read y :: Int)) . words) $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 dirs)
  putStrLn $ "Star 2: " ++ (show $ star2 dirs)
