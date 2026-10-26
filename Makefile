TEENSY_LOADER_CLI_BIN := "teensy_loader_cli"
TEENSY_LOADER_CLI_REPO := "teensy_loader_cli_repo"
# TEENSY_PORT := $(shell ls /dev/tty.usb* 2> /dev/null | head -1)
TEENSY_PORT := /dev/tty.usbmodem186602401
NAME := pedal-rs.hex

install:
	@git clone git@github.com:PaulStoffregen/teensy_loader_cli.git $(TEENSY_LOADER_CLI_REPO)
	@/usr/bin/cc -O2 -Wall -DUSE_APPLE_IOKIT -o $(TEENSY_LOADER_CLI_BIN) $(TEENSY_LOADER_CLI_REPO)/teensy_loader_cli.c -framework IOKit -framework CoreFoundation
	@rm -rf $(TEENSY_LOADER_CLI_REPO)

all:
	@cargo objcopy --release -- -O ihex $(NAME)

flash: all
	@echo "Press the Teensy button now..."
	@./teensy_loader_cli --mcu=TEENSY41 -w $(NAME)

monitor:
	minicom -D $(TEENSY_PORT) 115200
