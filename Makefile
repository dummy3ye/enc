# Makefile for enc utility

CC = gcc
CFLAGS = -O3 -Wall -Wextra
TARGET = enc
SRC = src/enc.c

# Detect OS for executable extension
ifeq ($(OS),Windows_NT)
    EXECUTABLE = $(TARGET).exe
    RM = del /Q
else
    EXECUTABLE = $(TARGET)
    RM = rm -f
endif

all: $(EXECUTABLE)

$(EXECUTABLE): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(EXECUTABLE)

clean:
	$(RM) $(EXECUTABLE)

install:
	powershell -ExecutionPolicy Bypass -File scripts/install.ps1

uninstall:
	powershell -ExecutionPolicy Bypass -File scripts/uninstall.ps1

.PHONY: all clean
