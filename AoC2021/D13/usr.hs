import qualified Data.Set as S
import Data.Text (splitOn, pack, unpack)

split = foldr (\c acc@(y:ys) -> if c == ',' then []:acc else (c:y):ys) [[]]

parse :: String -> ([(Int,Int)],[(Char,Int)])
parse ls = (coords',instr')
  where
    [coords,instr] = map unpack $ splitOn (pack "\n\n") (pack ls)
    coords' = map ((\[x,y]->(x,y)) . map read . split) $ lines coords
    instr' = map ((\(x:_:y)->(x,read y)) . drop 11) $ lines instr


aux ('x',v) (x,y) = if x < v then (x,y) else (x-2*(x-v),y)
aux ('y',v) (x,y) = if y < v then (x,y) else (x,y-2*(y-v))

applyFold s instr = foldr (S.insert . aux instr) S.empty (S.elems s)

see s p = if p `S.member` s then '#' else ' '

insertBreaks _ [] = ""
insertBreaks breakSz ls = x ++ '\n':insertBreaks breakSz xs
  where
    (x,xs) = splitAt breakSz ls

draw s = insertBreaks (mxx+1) $ map (see s) whiteSheet
  where
    elems = S.elems s
    mxx = maximum $ map fst elems
    mxy = maximum $ map snd elems
    whiteSheet = [(x,y) | y <- [0..mxy], x <- [0..mxx]]

s1 points instr = S.size $ applyFold points (head instr)
s2 points instr = draw $ foldl applyFold points instr

main :: IO ()
main = do
  contents <- getContents
  let (points,instr) = parse contents
  let points' = S.fromList points
  putStrLn $ "Star 1: " ++ (show $ s1 points' instr)
  putStrLn $ "Star 2: \n" ++ (s2 points' instr)
