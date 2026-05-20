CC = gcc
CFLAGS = -O3 -Wall -Wextra
TARGET = enc
SRC = enc.c

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

bin:
	$(CC) $(CFLAGS) $(SRC) -o bin/$(TARGET).exe

clean:
	$(RM) $(EXECUTABLE)

install:
	powershell -ExecutionPolicy Bypass -File install.ps1

uninstall:
	powershell -ExecutionPolicy Bypass -File scripts/uninstall.ps1

.PHONY: all clean
