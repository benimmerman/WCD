#!/bin/bash

filenametime=$(date +"%Y-%m-%d %H:%M:%S")

export PYTHON_SCRIPT_NAME=$(cat config.toml | grep 'py_script' | awk -F"=" '{print $2}' | tr -d '"') # get the py_script from config.toml, and remove the quotes
export SHELL_SCRIPT_NAME='run.sh'
export SCRIPTS_FOLDER=$(pwd)
export LOGDIR=$SCRIPTS_FOLDER/log
export LOG_FILE=${LOGDIR}/${SHELL_SCRIPT_NAME}_${filenametime}.log # ${SHELL_SCRIPT_NAME} --> look this up

cd ${SCRIPTS_FOLDER}

exec > >(tee ${LOG_FILE}) 2>&1

source sandbox/bin/activate
echo "Start to run Python Script"
python3 ${SCRIPTS_FOLDER}/${PYTHON_SCRIPT_NAME}

RC1=$?
if [ ${RC1} != 0 ]; then
	echo "PYTHON RUNNING FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi

echo "PROGRAM SUCCEEDED"

deactivate

exit 0 