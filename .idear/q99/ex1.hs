myLast :: [a] -> a
myLast [] = error "Empty list"
myLast [x] = x
myLast (_:xs) = myLast xs

myLast' :: [a] -> a
myLast' = head . reverse

myLast'' :: [a] -> a
myLast'' = foldl1 (curry snd)

main = do
  let x1 = myLast [1, 2, 3, 4]
  let x2 = myLast' [1, 2, 3, 4]
  let x3 = myLast'' [1, 2, 3, 4]
  let x = last [1, 2, 3, 4]
  print x1
  print x2
  print x3
  print x
