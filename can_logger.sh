#!/bin/bash

# 設定ファイルのパス
CONFIG_FILE="/etc/can_logger.conf"


# 設定ファイルからログディレクトリを読み込む
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "設定ファイルが見つかりません: $CONFIG_FILE"
    exit 1
fi

mkdir -p "$LOG_DIR"

# 現在時刻を取得して初期ファイル名を生成
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
LOG_FILE="${LOG_DIR}/canlog_${TIMESTAMP}.log"

# CANバスデータの収集とログファイルへの出力
candump -ta $CAN_INTERFACE | while read -r line; do
    # ログファイルにデータを書き込み
    echo "$line" >> "$LOG_FILE"

    # 500KBごとにファイルを分割
    if [[ $(stat -c%s "$LOG_FILE") -ge $SPLIT_SIZE ]]; then
        mv "$LOG_FILE" "${LOG_FILE%.log}_$(date +"%Y%m%d%H%M%S").log"
        TIMESTAMP=$(date +"%Y%m%d%H%M%S")
        LOG_FILE="${LOG_DIR}/canlog_${TIMESTAMP}.log"
    fi

    # ログディレクトリ内のファイルサイズの合計をチェック
    TOTAL_SIZE=$(du -b $LOG_DIR | awk '{print $1}')
    while [[ $TOTAL_SIZE -gt $MAX_TOTAL_SIZE ]]; do
        # 最も古いファイルを削除
        OLDEST_FILE=$(ls -t $LOG_DIR | tail -1)
        rm "$LOG_DIR/$OLDEST_FILE"
        TOTAL_SIZE=$(du -b $LOG_DIR | awk '{print $1}')
    done
done
