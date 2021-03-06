#!/usr/bin/env bash

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
t 03 1 2972336
t 03 2 3368358
t 04 1 23177
t 04 2 6804
t 05 1 5169
t 05 2 22083
t 06 1 389726
t 06 2 1743335992042
