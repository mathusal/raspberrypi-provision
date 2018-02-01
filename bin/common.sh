#!/bin/bash

title() {
  LENGTH=$(( ${#1} +4 ))
  printf '#%.0s' $(seq 1 ${LENGTH})
  echo
  echo "# $1 #"
  printf '#%.0s' $(seq 1 ${LENGTH})
  echo
  echo
}

message() {
  echo "[ $1 ]"
  echo
}
