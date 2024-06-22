# Makefile for installing and uninstalling CAN logger script and service

# Variables
SCRIPT_NAME=can_logger.sh
SERVICE_NAME=can_logger.service
CONFIG_NAME=can_logger.conf
INSTALL_DIR=/usr/local/bin/can_logger
SERVICE_DIR=/etc/systemd/system
CONFIG_DIR=/etc
SCRIPT_PATH=$(INSTALL_DIR)/$(SCRIPT_NAME)
SERVICE_PATH=$(SERVICE_DIR)/$(SERVICE_NAME)
CONFIG_PATH=$(CONFIG_DIR)/$(CONFIG_NAME)

# Installation
install: $(SCRIPT_PATH) $(SERVICE_PATH) $(CONFIG_PATH)
	sudo systemctl daemon-reload
	sudo systemctl enable $(SERVICE_NAME)
	sudo systemctl start $(SERVICE_NAME)
	echo "Installation complete."

$(SCRIPT_PATH): $(SCRIPT_NAME)
	sudo mkdir -p $(INSTALL_DIR)
	sudo cp $(SCRIPT_NAME) $(SCRIPT_PATH)
	sudo chmod +x $(SCRIPT_PATH)

$(SERVICE_PATH): $(SERVICE_NAME)
	sudo cp $(SERVICE_NAME) $(SERVICE_PATH)

$(CONFIG_PATH): $(CONFIG_NAME)
	sudo cp $(CONFIG_NAME) $(CONFIG_PATH)

# Uninstallation
uninstall:
	sudo systemctl stop $(SERVICE_NAME)
	sudo systemctl disable $(SERVICE_NAME)
	sudo rm -f $(SERVICE_PATH)
	sudo rm -rf $(INSTALL_DIR)
	sudo rm -f $(CONFIG_PATH)
	sudo systemctl daemon-reload
	echo "Uninstallation complete."

.PHONY: install uninstall
