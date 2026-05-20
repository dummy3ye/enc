# enc

A lightweight, zero-dependency CLI encryption tool.

## Installation

### Quick Install (Windows)
Run the following in PowerShell:
```powershell
iwr -useb https://raw.githubusercontent.com/dummy3ye/enc/master/scripts/get.ps1 | iex
```

### Manual Build
1. Clone the repo: `git clone https://github.com/dummy3ye/enc`
2. Build with `make` (requires GCC)
3. Install: `make install`

## Usage

### Encryption
```bash
# String to hex
enc -e "my text" -key "password"

# File to hex
enc -e input.txt -key "mysecret" -o output.hex
```

### Decryption
```bash
# Hex to string
enc -d "4be41ef2..." -key "password"

# File to plain text
enc -d output.hex -key "mysecret" -o restored.txt
```

## Key Management
- **Manual:** Pass `-key "yourkey"`
- **File:** Pass `-f "keyfile.txt"`
- **Automatic:** If no key is provided, `enc` looks for `key.txt` in the current directory.

## Uninstall
```powershell
make uninstall
```
