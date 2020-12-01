zeros = [0,0,0,0]--take 4 $ [0,0..]

initx = State [17, 2, -1, 4] zeros
inity = State [-9, 2, 5, 7] zeros
initz = State [4, -13, -1, -7] zeros

data State = State [Int] [Int] deriving (Show, Eq)

energy :: [State] -> Int
energy = foldr sumEnergies 0
    where
        sumEnergies :: State -> Int -> Int
        sumEnergies (State pos vel) acc = acc + (sumAbs pos * sumAbs vel)
        sumAbs = sum . map abs

newSpeeds :: [Int] -> [Int] -> [Int]
newSpeeds (x:xs) poss = calcSpeed poss : newSpeeds xs poss
    where
        calcSpeed (p:ps) = (if x < p then 1 else if x == p then 0 else -1) + calcSpeed ps
        calcSpeed [] = 0
newSpeeds [] _ = []

--zipWith (+) seems to double the time it takes
addTwoArr :: [Int] -> [Int] -> [Int]
addTwoArr (a:as) (b:bs) = a + b : addTwoArr as bs
addTwoArr [] [] = []

next :: State -> State
next (State ps vs) = State (addTwoArr ps nextSpeed) nextSpeed
    where
        nextSpeed = addTwoArr (newSpeeds ps ps) vs

--This generates an infine list of states, cool!
states :: State -> [State]
states s = s : states (next s)        

--There is probably a better way
toBodies :: State -> State -> State -> [State]
toBodies (State px vx) (State py vy) (State pz vz) = aux px vx py vy pz vz
    where
        aux (px:pxs) (vx:vxs) (py:pys) (vy:vys) (pz:pzs) (vz:vzs) = State [px,py,pz] [vx,vy,vz] : aux pxs vxs pys vys pzs vzs
        aux _ _ _ _ _ _ = []

period :: State -> State -> Integer -> Integer
period s1 s2 acc = if s1 == nxt then acc else period s1 nxt (acc+1)
    where
        nxt = next s2

--lcm and gcd are already in the Prelude for 2 variables
lcm' :: [Integer] -> Integer
lcm' = foldl1 lcm

star1 :: Int -> Int
star1 l = energy $ toBodies x y z
    where
        x = last $ take l $ states initx
        y = last $ take l $ states inity
        z = last $ take l $ states initz

star2 :: Integer
star2 = lcm' [periodx, periody, periodz]
    where
        periodx = period initx initx 1
        periody = period inity inity 1
        periodz = period initz initz 1

main :: IO ()
main = do
    putStrLn $ "Star 1: " ++ (show $ star1 1001)
    putStrLn $ "Star 2: " ++ (show star2)
