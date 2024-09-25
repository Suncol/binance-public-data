# Bash script who permit to download the perpetuals futures fundingRate simultaneously.
# That's mean that the script create few sub-processes for download the data asynchronously

CM_OR_UM="um"
# SYMBOLS=(AAVEUSD_PERP ADAUSD_PERP ATOMUSD_PERP AVAXUSD_PERP AXSUSD_PERP BCHUSD_PERP BNBUSD_PERP BTCUSD_PERP CRVUSD_PERP DOGEUSD_PERP DOTUSD_PERP EGLDUSD_PERP EOSUSD_PERP ETCUSD_PERP ETHUSD_PERP FILUSD_PERP FTMUSD_PERP GALAUSD_PERP LINKUSD_PERP LTCUSD_PERP LUNAUSD_PERP MANAUSD_PERP MATICUSD_PERP NEARUSD_PERP ROSEUSD_PERP SANDUSD_PERP SOLUSD_PERP THETAUSD_PERP TRXUSD_PERP UNIUSD_PERP XLMUSD_PERP XRPUSD_PERP XTZUSD_PERP)
SYMBOLS=(BTCUSDT)
# mapfile -t SYMBOLS < um_symbols.txt
echo "SYMBOLS: ${SYMBOLS[@]}"
YEARS=("2019" "2020" "2021" "2022" "2023" "2024")
# YEARS=("2024")
MONTHS=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12")
OUTPUT_BASE_DIR="/home/nas/user_data/suncong/binance_data/fundingRate/${CM_OR_UM}"

# First we verify if the CM_OR_UM is correct, if not, we exit
if [ "$CM_OR_UM" = "cm" ] || [ "$CM_OR_UM" == "um" ]; then
  BASE_URL="https://data.binance.vision/data/futures/${CM_OR_UM}/monthly/fundingRate"
else
  echo "CM_OR_UM can be only cm or um"
  exit 0
fi


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

for symbol in ${SYMBOLS[@]}; do
    for year in ${YEARS[@]}; do
        for month in ${MONTHS[@]}; do
            url="${BASE_URL}/${symbol}/${symbol}-fundingRate-${year}-${month}.zip"
            output_dir="${OUTPUT_BASE_DIR}/${symbol}"
            download_url "${url}" "${output_dir}" &
        done
        wait
    done