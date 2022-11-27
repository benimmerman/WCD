#!/bin/bash

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt install python3.8 -y
sudo apt install python3.8-distutils -y
sudo apt-get install python3-pandas
sudo apt install awscli -y

pip install python-dotenv
pip install toml
pip install sqlalchemy
pip install boto3

# Create a virtual environment for specific python3.8 version
sudo apt install python3-virtualenv -y
virtualenv --python="/usr/bin/python3.8" sandbox  
# runs the sandbox virtual environment
source sandbox/bin/activate 

pip install -r requirements.txt

deactivate # deactivate your sandbox

chmod a+x run.sh # make run.sh executable

mkdir -p log # create log directory if it doesn't exist