#!/bin/bash

if [ ! -d "./keys/" ]; then
    mkdir keys
fi

gen_keys() {
    if [ ! -f "$1" ] && [ ! -f "$1.pub" ]; then 
        rm -rf keys/$1*
        ssh-keygen -t rsa -b 4096 -C $1 -f keys/$1 -q -N ""
    fi
}

gen_keys "bastion"
gen_keys "client"
gen_keys "nat"