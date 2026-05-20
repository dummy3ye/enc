# enc - Lightweight Secure CLI Encryption Tool

A single-file, zero-dependency CLI utility for secure encryption and decryption using a custom state-mutating stream cipher.

## Features
- **Zero Dependencies:** Pure standard C code.
- **Custom State-Mutating Cipher:** Prevents frequency analysis by mutating the internal state after every byte.
- **Flexible Key Management:** Load keys from strings, files, or a default `key.txt`.
- **File Input/Output:** Encrypt/decrypt raw strings or file contents with ease.
- **Clean CLI:** Standard help flags and dynamic argument parsing.

## Directory Structure
- `src/`: Contains the source code (`enc.c`).
- `scripts/`: Installation and uninstallation scripts for Windows PowerShell.
- `Makefile`: Build automation for development.

## Installation (Windows)

### Quick One-Liner (Remote)
Open PowerShell and run:
```powershell
iwr -useb https://github.com/dummy3ye/enc/blob/master/scripts/get.ps1 | iex
```

### Manual Installation (Local)
To install globally from a cloned repo:
```powershell
# Using the Makefile
make install

# OR running the script directly
.\scripts\install.ps1
```

## Quick Start

### Encryption
```bash
# Encrypt a string
enc -e "hello world" -key "mysecret"

# Encrypt a file
enc -e input.txt -key "mysecret" -o output.hex
```

### Decryption
```bash
# Decrypt a hex string
enc -d "4be41ef2..." -key "mysecret"

# Decrypt a file
enc -d output.hex -key "mysecret" -o restored.txt
```

### Key from File
If no `-key` is provided, `enc` looks for `key.txt` in the current directory. You can also specify a custom key file:
```bash
enc -e "secret message" -f my_key_file.txt
```

## Build for Development
```bash
make
```

## License
MIT (or choose your preferred license)
