DP0=$( cd "$(dirname "$0")" ; pwd -P )
java -jar "$DP0/xjparse.jar" -S "$1" "$2"
errorRet=$?
exit $errorRet
