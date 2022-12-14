#!/bin/bash

if [ "$3" = "" ]; then echo Missing results directory, platform, and dateZ arguments ; exit 1 ; fi

# Configuration parameters

export platform=$2
export targetdir="$1"
export dateTime=$3
export numberOfProcesses=5

export ssGoogle=https://docs.google.com/spreadsheets/d/1_FDegvpa960uTHhzMPjNGWoBIPkNd1-81rBfKNCKncY

bash prepareValidationArtefacts-common.sh "$1" "$2" "$3" "$4"

exit 0 # always be successful so that github returns ZIP of results
