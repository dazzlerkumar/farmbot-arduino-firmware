TARGET_farmduino_v10_BUILD_DIR := $(BUILD_DIR)/farmduino_v10
TARGET_farmduino_v10_HEX := $(BIN_DIR)/farmduino.hex

TARGET_farmduino_v10_OBJ := $(patsubst $(FBARDUINO_FIRMWARE_SRC_DIR)/%,$(TARGET_farmduino_v10_BUILD_DIR)/%,$(CXX_OBJ))

$(TARGET_farmduino_v10_HEX): $(TARGET_farmduino_v10_BUILD_DIR) $(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.eep $(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.elf
	$(OBJ_COPY) -O ihex -R .eeprom  $(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.elf $@

$(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.eep: $(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.elf
	$(OBJ_COPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0  $< $@

$(TARGET_farmduino_v10_BUILD_DIR)/farmduino_v10.elf: $(TARGET_farmduino_v10_OBJ)
	$(CC) -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections,--relax -mmcu=atmega2560 -o $@ $(TARGET_farmduino_v10_OBJ) $(DEPS_OBJ) $(DEP_CORE_LDFLAGS)

$(TARGET_farmduino_v10_BUILD_DIR)/%.o: $(FBARDUINO_FIRMWARE_SRC_DIR)/%.cpp $(HEADERS)
	$(CXX) $(CXX_FLAGS) -DFARMBOT_BOARD_ID=1 $(DEPS_CFLAGS) $< -o $@

$(TARGET_farmduino_v10_BUILD_DIR):
	$(MKDIR_P) $(TARGET_farmduino_v10_BUILD_DIR)

target_farmduino_v10: $(TARGET_farmduino_v10_HEX)

target_farmduino_v10_clean:
	$(RM) -r $(TARGET_farmduino_v10_OBJ)
	$(RM) $(TARGET_farmduino_v10_HEX)
