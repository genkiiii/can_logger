#!/bin/bash

INTERFACE="can0"

# can0インターフェースの確認
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    echo "$INTERFACE インターフェースが存在しません。"
    exit 1
fi

# 終了処理の定義
trap "echo '終了します。'; exit 0" SIGINT

echo "Ctrl+Cを押すまで適当なCANメッセージを${INTERFACE}に出力します。"

while true; do
    # ランダムなCANメッセージを生成
    ID=$(printf "%03X" $((RANDOM % 2048)))     # 11ビットのCAN IDを生成
    DATA=$(for i in {1..8}; do printf "%02X" $((RANDOM % 256)); done)  # ランダムな8バイトのデータを生成

    # CANメッセージを送信
    cansend $INTERFACE $ID#$DATA

done
