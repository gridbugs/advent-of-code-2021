#!/bin/sh

t() {
    day=$1
    question=$2
    result=$3

    diff <(dune exec day${day}_$question < input/day${day}.txt) <(echo ${result})
}

t 01 1 1832
t 01 2 1858
t 02 1 1524750
t 02 2 1592426537
