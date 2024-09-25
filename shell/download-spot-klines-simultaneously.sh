# Bash script who permit to download the perpetuals futures klines simultaneously.
# That's mean that the script create few sub-processes for download the data asynchronously

# SYMBOLS=(AAVEUSD_PERP ADAUSD_PERP ATOMUSD_PERP AVAXUSD_PERP AXSUSD_PERP BCHUSD_PERP BNBUSD_PERP BTCUSD_PERP CRVUSD_PERP DOGEUSD_PERP DOTUSD_PERP EGLDUSD_PERP EOSUSD_PERP ETCUSD_PERP ETHUSD_PERP FILUSD_PERP FTMUSD_PERP GALAUSD_PERP LINKUSD_PERP LTCUSD_PERP LUNAUSD_PERP MANAUSD_PERP MATICUSD_PERP NEARUSD_PERP ROSEUSD_PERP SANDUSD_PERP SOLUSD_PERP THETAUSD_PERP TRXUSD_PERP UNIUSD_PERP XLMUSD_PERP XRPUSD_PERP XTZUSD_PERP)
# SYMBOLS=(BTCUSDT)
mapfile -t SYMBOLS < um_symbols.txt
echo "SYMBOLS: ${SYMBOLS[@]}"
# INTERVALS=("1m" "5m" "15m" "30m" "1h" "2h" "4h" "6h" "8h" "12h" "1d" "3d" "1w" "1mo")
INTERVALS=("1s")
YEARS=("2017" "2018" "2019" "2020" "2021" "2022" "2023" "2024")
# YEARS=("2024")
MONTHS=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12")
OUTPUT_BASE_DIR="/home/nas/user_data/suncong/binance_data/spot/klines_1s"

BASE_URL="https://data.binance.vision/data/spot/monthly/klines"


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
        url="${BASE_URL}/${symbol}/${interval}/${symbol}-${interval}-${year}-${month}.zip"

        output_dir="${OUTPUT_BASE_DIR}/${symbol}"
        download_url "${url}" "${output_dir}" &
      done
      wait
    done
  done
done
