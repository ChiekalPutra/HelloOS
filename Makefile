# Compiler and tools
AS = i686-elf-as
CC = i686-elf-gcc
LD = i686-elf-ld
QEMU = qemu-system-i386


# Compilation flags
CFLAGS = -ffreestanding -O2 -Wall -Wextra -std=gnu99

# Directories
BUILD_DIR = build
SRC_DIR = .
BOOT_SRC = $(SRC_DIR)/boot.s
KERNEL_SRC = $(SRC_DIR)/kernel.c
LINKER_SCRIPT = $(SRC_DIR)/linker.ld

# Object files
BOOT_OBJ = $(BUILD_DIR)/boot.o
KERNEL_OBJ = $(BUILD_DIR)/kernel.o

# Output binary
OUTPUT_BIN = $(BUILD_DIR)/hello_os.bin

# Default target
all: setup $(OUTPUT_BIN)

# Create build directory
setup:
	mkdir -p $(BUILD_DIR)

# Assemble boot.s
$(BOOT_OBJ): $(BOOT_SRC)
	$(AS) $(BOOT_SRC) -o $(BOOT_OBJ)

# Compile kernel.c
$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) -c $(KERNEL_SRC) -o $(KERNEL_OBJ) $(CFLAGS)

# Link object files into a binary
$(OUTPUT_BIN): $(BOOT_OBJ) $(KERNEL_OBJ) $(LINKER_SCRIPT)
	$(LD) -T $(LINKER_SCRIPT) -o $(OUTPUT_BIN) -nostdlib $(BOOT_OBJ) $(KERNEL_OBJ)

# Test the Kernel on qemu-i386
run : $(OUTPUT_BIN)
	$(QEMU) -kernel $(OUTPUT_BIN)

# Clean build files
clean:
	rm -rf $(BUILD_DIR)
