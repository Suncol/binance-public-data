#!/bin/bash

# source venv
source /home/suncong/work/trading/.venv/bin/activate
cd /home/suncong/work/trading/binance-public-data/pipeline
# run luigi
# luigi --module test_luigi RunAutoUpdateDaily --local-scheduler
python test_luigi.py 