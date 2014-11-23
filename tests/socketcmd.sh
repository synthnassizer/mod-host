#!/bin/bash

LV2PLUGIN="$@"
#echo ${LV2PLUGIN}
echo "${LV2PLUGIN}" | nc localhost 5555
