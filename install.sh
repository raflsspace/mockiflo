#!/usr/bin/env bash
set -e

# Terminal output colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} Installing MockiFlo CLI..."

# 1. Detect Operating System
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE="linux";;
    Darwin*)    OS_TYPE="macos";;
    *)          echo -e "${RED}Error: Unsupported Operating System (${OS})${NC}"; exit 1;;
esac

# 2. Detect Machine Architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64*)    ARCH_TYPE="amd64";;
    aarch64*)   ARCH_TYPE="arm64";;
    arm64*)     ARCH_TYPE="arm64";;
    *)          echo -e "${RED}Error: Unsupported Architecture (${ARCH})${NC}"; exit 1;;
esac

# 3. Match release binary naming convention
if [ "${OS_TYPE}" = "macos" ]; then
    if [ "${ARCH_TYPE}" = "arm64" ]; then
        BINARY="mockiflo-macos-arm64"
    else
        BINARY="mockiflo-macos-intel"
    fi
else
    if [ "${ARCH_TYPE}" = "amd64" ]; then
        BINARY="mockiflo-linux-amd64"
    else
        echo -e "${RED}Error: Linux ARM is not currently supported.${NC}"; exit 1
    fi
fi

DOWNLOAD_URL="https://github.com/raflsspace/mockiflo/releases/latest/download/${BINARY}"
INSTALL_DIR="/usr/local/bin"
TARGET_FILE="${INSTALL_DIR}/mockiflo"

echo -e "${BLUE}==>${NC} Detected: ${OS_TYPE} (${ARCH_TYPE})"
echo -e "${BLUE}==>${NC} Downloading binary from GitHub Releases..."

# Download binary to a temporary file
TMP_FILE="$(mktemp)"
if command -v curl >/dev/null 2>&1; then
    curl -sSL -o "${TMP_FILE}" "${DOWNLOAD_URL}"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "${TMP_FILE}" "${DOWNLOAD_URL}"
else
    echo -e "${RED}Error: Neither curl nor wget is available.${NC}"
    exit 1
fi

chmod +x "${TMP_FILE}"

# Move executable to system bin directory
echo -e "${BLUE}==>${NC} Installing binary to ${INSTALL_DIR}..."
if [ -w "${INSTALL_DIR}" ]; then
    mv "${TMP_FILE}" "${TARGET_FILE}"
else
    echo -e "${BLUE}==>${NC} Administrator privilege required to write to ${INSTALL_DIR}."
    sudo mv "${TMP_FILE}" "${TARGET_FILE}"
fi

echo -e "${GREEN}==> MockiFlo CLI installed successfully!${NC}"
echo -e "Run '${GREEN}mockiflo --help${NC}' to get started."
