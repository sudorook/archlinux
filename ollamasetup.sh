#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to detect package manager
detect_package_manager() {
    if command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v apt-get &> /dev/null; then
        echo "apt-get"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

# Function to install packages
install_package() {
    local package=$1
    local pm=$(detect_package_manager)
    
    case $pm in
        pacman)
            sudo pacman -S --noconfirm $package
            ;;
        apt-get)
            sudo apt-get update
            sudo apt-get install -y $package
            ;;
        dnf)
            sudo dnf install -y $package
            ;;
        *)
            echo "Unsupported package manager. Please install $package manually."
            return 1
            ;;
    esac
}

# Install Ollama
install_ollama() {
    echo -e "${BLUE}Installing Ollama...${NC}"
    curl https://ollama.ai/install.sh | sh
}

# Install dependencies
install_dependencies() {
    echo -e "${BLUE}Installing dependencies...${NC}"
    install_package curl
    install_package wget
}

# Detect and install GPU drivers
install_gpu_drivers() {
    if lspci | grep -i nvidia &> /dev/null; then
        echo -e "${YELLOW}NVIDIA GPU detected. Installing CUDA...${NC}"
        install_package nvidia-cuda-toolkit
    elif lspci | grep -i amd &> /dev/null; then
        echo -e "${YELLOW}AMD GPU detected. Installing ROCm...${NC}"
        # ROCm installation varies by distro, this is a simplified version
        install_package rocm-opencl-runtime
    else
        echo -e "${YELLOW}No supported GPU detected. Skipping GPU acceleration setup.${NC}"
    fi
}

# Function to download and install Ollama models
install_models() {
    local models=("llama2" "codellama" "mistral" "vicuna" "orca-mini" "neural-chat")
    local selected=()

    echo -e "${BLUE}Select models to install (use space to select, enter to confirm):${NC}"
    PS3="Enter the number of your choice (or 0 when done): "
    select model in "${models[@]}" "Done"; do
        if [[ "$model" == "Done" || -z "$model" ]]; then
            break
        fi
        if [[ ! " ${selected[@]} " =~ " ${model} " ]]; then
            selected+=("$model")
            echo -e "${GREEN}Selected: $model${NC}"
        fi
    done

    for model in "${selected[@]}"; do
        echo -e "${YELLOW}Downloading and installing $model...${NC}"
        ollama pull $model
    done
}

# Configure Ollama
configure_ollama() {
    echo -e "${BLUE}Configuring Ollama...${NC}"
    # Create a basic configuration file
    cat << EOF > ~/.ollama/config.yaml
gpu: auto
models_path: ~/.ollama/models
EOF
    echo -e "${GREEN}Ollama configured. You can modify ~/.ollama/config.yaml for advanced settings.${NC}"
}

# Main execution
echo -e "${YELLOW}Welcome to the Ollama installation script!${NC}"

install_dependencies
install_gpu_drivers
install_ollama
install_models
configure_ollama

echo -e "${GREEN}Ollama installation and configuration complete!${NC}"
echo -e "${YELLOW}To start using Ollama, run: ollama run <model_name>${NC}"
echo -e "${BLUE}Thanks for using this script by techlogicals${NC}"
