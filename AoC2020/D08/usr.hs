import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Maybe (fromJust)
import Data.Either (lefts)

data Op = Nop Int | Acc Int | Jmp Int deriving (Show)
data State = State (Map.Map Int Op, Int, Int) | Terminated Int deriving (Show)

parse :: String -> Op
parse ('n':'o':'p':ss) = Nop (read ss)
parse ('a':'c':'c':ss) = Acc (read ss)
parse ('j':'m':'p':ss) = Jmp (read ss)
parse str = error $ "Unknown op " ++ str

applyOp :: Op -> State -> State
applyOp (Nop _) (State (m,idx,acc)) = State (m,idx+1,acc)
applyOp (Jmp i) (State (m,idx,acc)) = State (m,idx+i,acc)
applyOp (Acc i) (State (m,idx,acc)) = State (m,idx+1,acc+i)

nxt :: State -> State
nxt state@(State (m,idx,acc)) = case idx `Map.lookup` m of
        Just instruction -> applyOp instruction state
        Nothing -> (Terminated acc)
nxt term = term

execute :: State -> Set.Set Int -> Either Int Int
execute (Terminated acc) _ = Right acc
execute state@(State (m,i,acc)) set = case i `Set.member` set of 
                True -> Left acc
                otherwise -> execute (nxt state) (i `Set.insert` set)

genState :: [Op] -> State
genState = (\x -> State (x,0,0)) . Map.fromList . zip [0..]

allPossibilities :: [Op] -> [[Op]]
allPossibilities ops = aux ops [] []
    where
        aux (o:os) prev acc = case o of
                Jmp i -> aux os nprev ((prev ++ (Nop i):os):acc)
                Nop i -> aux os nprev ((prev ++ (Jmp i):os):acc)
                otherwise -> aux os nprev acc
                where nprev = prev ++ [o]
        aux _ _ acc = acc

star1 ops = (head . lefts) [execute (genState ops) Set.empty]
star2 ops = (aux . map genState . allPossibilities) ops
    where
        aux (state:rest) = case execute state Set.empty of
            Right acc -> acc
            otherwise -> aux rest

main :: IO ()
main = do
  contents <- getContents
  let ops = map (parse . filter (/='+')) $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ops)
  putStrLn $ "Star 2: " ++ (show $ star2 ops)
