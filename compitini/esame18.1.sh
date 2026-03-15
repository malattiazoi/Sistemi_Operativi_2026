#!/bin/bash
echo eseguito
PS1='$(ps -e | wc -l) > '
echo $PS1