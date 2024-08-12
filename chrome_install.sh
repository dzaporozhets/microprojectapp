#!/bin/bash

# Install necessary dependencies
apt-get update -qq
apt-get install -y \
  libnss3 \
  libgconf-2-4 \
  libxi6 \
  libxcursor1 \
  libxcomposite1 \
  libasound2 \
  libxdamage1 \
  libxtst6 \
  libglib2.0-0 \
  libxrandr2 \
  libxss1 \
  libx11-xcb1 \
  wget \
  curl \
  unzip

# Hardcoded Chrome version
CHROME_VERSION="114.0.5735.198"
echo "Using hardcoded Chrome version: $CHROME_VERSION"

# Download and install the specific version of Google Chrome
wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb
dpkg -i google-chrome-stable_${CHROME_VERSION}-1_amd64.deb
apt-get install -f -y  # Install any dependencies that might be missing
rm google-chrome-stable_${CHROME_VERSION}-1_amd64.deb

# Hardcoded Chromedriver version
CHROMEDRIVER_VERSION="114.0.5735.90"
echo "Using hardcoded Chromedriver version: $CHROMEDRIVER_VERSION"

echo "Installing chromedriver from https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

echo "Chrome and Chromedriver setup complete."

