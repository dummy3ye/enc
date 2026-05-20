# enc

a cli tool for text encode and decoding

## Installation

### Quick Install (Windows)

Run the following in PowerShell (no compiler required):

```powershell
iwr -useb https://raw.githubusercontent.com/dummy3ye/enc/master/scripts/get.ps1 | iex
```

### Manual Build

If you wish to compile from source:

1. `make bin`
2. Manually copy `bin/enc.exe` to your installation directory.

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
