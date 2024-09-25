#!/bin/bash 
work_dir="/home/suncong/work/trading/binance-public-data/shell"
log_dir="/home/nas/user_data/suncong/binance_data/logs"
echo $(date)

source /opt/software/v2ray/set_proxy.sh
proxy

cd $work_dir
. ./fetch-all-trading-pairs.sh

echo "--------------------------------Downloading daily klines data-------------------"


######### Serial Download #########
echo "Downloading for Futures!!!!"

./daily_update_future_klines.sh
if [ $? -eq 0 ]; then
  echo "daily_update_future_klines.sh executed successfully"
else
  echo "daily_update_future_klines.sh failed"
fi

echo "Downloading for Spot!!!!"

./daily_update_spot_klines.sh
if [ $? -eq 0 ]; then
    echo "daily_update_spot_klines.sh executed successfully"
else
    echo "daily_update_spot_klines.sh failed"
fi


echo "--------------------------------Downloaded daily klines data-------------------"



# echo "Downloading daily trades data"
