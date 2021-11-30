# Programing Advent

This is a public repository where we will place the code of solutions to [AOC](https://adventofcode.com/)

## About

There is a challenge every day until the 25th divided into 2 related sub-challenges (called stars), they get increasingly harder to solve.

## How to upload

1- Write a single file to solve both stars:
 * Don't include any personal information or information about your dataset (such as number of lines).
 * Don't hardcode the dataset path, use cmd args or relative paths (*don't*: `open("/home/user/../D12/info.txt")` *do*: `open("info.txt"); cat info.txt | ./solve; ./solve '/home/user/../info.txt'`, depends on how you set it up) 
 * The same script should solve both stars at the same time `$ ./solve -> Star1: 7, Star2: 128`

2- `$git pull origin master` to ensure you are up to date.

3- Place the code into the corresponding folder (D[num of day] e.g: D1, D21), if there is none, make it.

4- `$git add` JUST the code, the gitignore should take care of the rest but ensure you only commit the code.

5- `$git commit -m "D[num] [about]"` commit with a simple message including the day.

6- `$git push origin master` upload to the github. Make sure everything works, it is a hassle to delete things in a public repo.
