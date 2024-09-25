#!/bin/bash

CM_OR_UM="um"
source /opt/software/v2ray/set_proxy.sh
proxy

mapfile -t SYMBOLS < um_symbols.txt
echo "SYMBOLS: ${SYMBOLS[@]}"
INTERVALS=("1s")

YEARS=($(date +"%Y"))
MONTHS=($(date +"%m"))
DATE=$(date -d "yesterday" +"%d")

OUTPUT_BASE_DIR="/home/nas/user_data/suncong/binance_data/spot/klines_daily_update/${CM_OR_UM}"

# Check if the output base directory exists, if not, create it
if [ ! -d "${OUTPUT_BASE_DIR}" ]; then
  mkdir -p "${OUTPUT_BASE_DIR}"
fi


BASE_URL="https://data.binance.vision/data/spot/daily/klines"

# Function who download the URL, this function is called asynchronously by several child processes
download_url() {
  url=$1
  output_dir=$2
  mkdir -p "${output_dir}"

  response=$(wget --server-response -q ${url} -P "${output_dir}" 2>&1 | awk 'NR==1{print $2}')
  if [ ${response} == '404' ]; then
    echo "File not exist: ${url}"
  else
    echo "downloaded: ${url} to ${output_dir}"
  fi
}

# Main loop who iterate over all the arrays and launch child processes
for symbol in ${SYMBOLS[@]}; do
  for interval in ${INTERVALS[@]}; do
    for year in ${YEARS[@]}; do
      for month in ${MONTHS[@]}; do
        url="${BASE_URL}/${symbol}/${interval}/${symbol}-${interval}-${year}-${month}-${DATE}.zip"

        output_dir="${OUTPUT_BASE_DIR}/${symbol}"
        download_url "${url}" "${output_dir}" &
      done
      wait
    done
  done
done