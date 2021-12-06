import qualified Data.Map as M
import qualified Data.Sequence as S

split = foldr (\c acc@(y:ys) -> if c == ',' then []:acc else (c:y):ys) [[]]

toMap = M.unionWith (+) baseMap . foldr (\x acc -> M.insertWith (+) x 1 acc) M.empty
  where
    baseMap = M.fromList $ take 9 $ zip [0..] (repeat 0)

rotateAndAdd (a S.:<| rest) = rest' S.|> a
  where rest' = S.adjust' (+a) 6 rest

star s n = foldr1 (+) $ foldr (\_ acc -> rotateAndAdd acc) s [1..n]

main :: IO ()
main = do
  contents <- getContents
  let fish = S.fromList $ M.elems $ toMap $ map read $ split contents
  putStrLn $ "Star 1: " ++ (show $ star fish 80)
  putStrLn $ "Star 2: " ++ (show $ star fish 256)
