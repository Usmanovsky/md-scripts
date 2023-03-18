#!/bin/bash
# launch a new tmux
namee='jupyter'
session=${1:-$namee}
tmux new -s $1
