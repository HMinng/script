#!/bin/bash
# @describe:
# @author:   Ming He(jackhm18@gmail.com)

process='cli.php'

num=$(ps -elf | grep $process | grep -v grep | wc -l);

if [ "$num" -eq 0 ]; then
   php public/cli.php request_uri="/anticheat/index"  &; 
fi

