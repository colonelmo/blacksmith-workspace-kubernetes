# CHANNEL=stable
CHANNEL=beta
# CHANNEL=alpha

WORKSPACE_DIR=workspace

.PHONY: update clean

$(WORKSPACE_DIR)/config: config
	mkdir -p $(WORKSPACE_DIR)
	cp -rp config $(WORKSPACE_DIR)/

$(WORKSPACE_DIR)/keyring/CoreOS_Image_Signing_Key.asc:
	mkdir -p $(WORKSPACE_DIR)/keyring
	cd $(WORKSPACE_DIR)/keyring; wget -N https://coreos.com/security/image-signing-key/CoreOS_Image_Signing_Key.asc

$(WORKSPACE_DIR)/keyring/keyring.gpg: $(WORKSPACE_DIR)/keyring/CoreOS_Image_Signing_Key.asc
	gpg --no-default-keyring --keyring $(WORKSPACE_DIR)/keyring/keyring.gpg --import $(WORKSPACE_DIR)/keyring/CoreOS_Image_Signing_Key.asc

$(WORKSPACE_DIR)/files:
	mkdir -p $(WORKSPACE_DIR)/files

update: _update.sh $(WORKSPACE_DIR)/config $(WORKSPACE_DIR)/files $(WORKSPACE_DIR)/keyring/keyring.gpg
	./_update.sh $(WORKSPACE_DIR) $(CHANNEL)

clean:
	rm -rf $(WORKSPACE_DIR)
