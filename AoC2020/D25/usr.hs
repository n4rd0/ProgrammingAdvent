multModulo :: Int -> Int -> Int -> Int
multModulo modulo a b = (a * b) `rem` modulo

operation = multModulo 20201227

determineLoopSize :: Int -> Int
determineLoopSize pubKey = aux (operation 7) 1 1
    where
        aux op n i = if newn == pubKey then i else aux op newn (i+1)
            where newn = op n

transform :: Int -> Int -> Int
transform loopSize num = foldr (\_ acc -> operation num acc) num (replicate (loopSize-1) undefined) 

star1 [cardPubK,doorPubK] = uncurry transform mn
    where
        cardLoopSize = determineLoopSize cardPubK
        doorLoopSize = determineLoopSize doorPubK
        mn = min (cardLoopSize,doorPubK) (doorLoopSize,cardPubK)

main :: IO ()
main = do
  contents <- getContents
  let keys = map read $ lines contents :: [Int]

  putStrLn $ "Star 1: " ++ (show $ star1 keys)
  putStrLn $ "Star 1: Click the button :)"
