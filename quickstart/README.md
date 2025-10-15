# Mixlayer Quickstart

A simple command-line interface for interacting with Mixlayer AI models using the free Llama 3.1 8B Instruct model.

## Features

- **Streaming AI responses**: Get real-time responses from the Llama 3.1 8B model
- **Stdin input**: Pipe text or type multi-line input (Ctrl+D to finish)
- **Nix-managed**: Fully reproducible environment with Nix flakes
- **Automatic API key retrieval**: Uses `secret-tool` to securely store and retrieve API keys
- **Simple CLI**: Just run and start chatting

## Prerequisites

- **Nix** with flakes enabled
- **secret-tool** configured with your Mixlayer API key

### Setting up your API key

Store your Mixlayer API key using `secret-tool`:

```bash
secret-tool store --label="Mixlayer API" api mixlayer
# Enter your API key when prompted
```

## Usage

### Method 1: Using Nix (Recommended)

```bash
# Run the app
nix run .

# Pipe input from a file
cat myfile.txt | nix run .

# Interactive mode
nix run .
# Type your message, then press Ctrl+D
```

### Method 2: Development Shell

```bash
# Enter development environment
nix develop

# The shell will automatically install dependencies and set up your API key
# Then run the script manually
node index.mjs
```

## How it works

1. **API Key**: Automatically retrieves your Mixlayer API key from `secret-tool`
2. **Connection**: Establishes a WebSocket connection to Mixlayer AI
3. **Model**: Opens a sequence with the free `meta/llama3.1-8b-instruct-free` model
4. **Input**: Reads all input from stdin until EOF (Ctrl+D)
5. **Streaming**: Sends your message and streams the AI response in real-time
6. **Output**: Prints the response to stdout

## Project Structure

- `index.mjs`: Main Node.js script that handles the AI interaction
- `package.json`: Node.js dependencies (modelsocket library)
- `flake.nix`: Nix flake configuration for reproducible builds and development environment
- `flake.lock`: Locked Nix dependencies

## Nix Commands

```bash
# Build the package
nix build

# Run the app
nix run .

# Enter development shell
nix develop

# Check flake outputs
nix flake show

# Update dependencies
nix flake update
```

## Configuration

The script is pre-configured to use:
- **Model**: `meta/llama3.1-8b-instruct-free` (free tier)
- **WebSocket URL**: `wss://models.mixlayer.ai/ws`
- **Input method**: Stdin until EOF
- **Output**: Streaming to stdout

## Troubleshooting

### "Cannot find package 'modelsocket'"
Make sure you're using `nix run .` or `nix develop` - the Nix environment ensures all dependencies are available.

### "API key not found"
Ensure you've stored your Mixlayer API key with:
```bash
secret-tool store --label="Mixlayer API" api mixlayer
```

### "Connection failed"
Check your internet connection and ensure your API key is valid.

## Development

To modify the model or behavior:

1. Edit `index.mjs` to change the model ID, connection details, or input handling
2. For different models, replace `"meta/llama3.1-8b-instruct-free"` with your desired model ID
3. Update `package.json` if you need additional Node.js dependencies
4. Run `nix develop` to test changes in the development environment

## License

This project is provided as-is for educational and demonstration purposes.
