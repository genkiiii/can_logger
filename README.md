# can_logger

このプロジェクトは、CAN（Controller Area Network）の通信をログとして出力するためのシェルスクリプト、設定ファイル、およびMakefileを提供します。システム起動時に自動的にログを収集し、指定されたディレクトリに保存します。

## 動作環境
linux-can/can-utilsのcandumpを利用しています。
また、Ubuntu22.04でのみ動作確認済みです。

## ファイル構成

- `can_log.sh`: CAN通信をログとして出力するシェルスクリプト
- `can_log.service`: `systemd`サービスファイル
- `can_logger.conf`: ログの出力先ディレクトリを指定する設定ファイル
- `Makefile`: インストールおよびアンインストール用のMakefile

## インストール手順
1. linux-can/can-utilsをインストールします。

    ```sh
    sudo apt install can-utils
    ```

2. リポジトリをクローンします。

    ```sh
    git clone https://github.com/genkiiii/can_logger.git
    ```

3. confファイルを編集して、ログの出力先ディレクトリなどを設定します。

    - `can_logger.conf`: ログの出力先ディレクトリ、canインターフェースを設定します。

    ```sh
    LOG_DIR="/path/to/logfile"
    CAN_INTERFACE="can0"
    ```

4. `Makefile`を使用して、シェルスクリプト、サービスファイル、設定ファイルをインストールします。

    ```sh
    sudo make install
    ```

    これにより、以下の処理が行われます：
    - シェルスクリプトが`/usr/local/bin/can_logger`にコピーされます。
    - `systemd`サービスファイルが`/etc/systemd/system`にコピーされます。
    - 設定ファイルが`/etc`にコピーされます。
    - サービスが有効化され、起動します。

## アンインストール手順

1. `Makefile`を使用して、シェルスクリプト、サービスファイル、設定ファイルをアンインストールします。

    ```sh
    sudo make uninstall
    ```

    これにより、以下の処理が行われます：
    - サービスが停止し、無効化されます。
    - シェルスクリプト、サービスファイル、設定ファイルが削除されます。

## サービスのステータス確認

サービスが正常に動作しているかを確認するには、以下のコマンドを実行します。

```sh
sudo systemctl status can_log.service
