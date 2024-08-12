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
  libx11-xcb1

# Add the Google Chrome signing key and repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update -qq

# Hardcoded Chrome version
CHROME_VERSION="114.0.5735.198"
echo "Using hardcoded Chrome version: $CHROME_VERSION"

# Install the specific version of Google Chrome
apt-get install -y google-chrome-stable=$CHROME_VERSION-1

# Hardcoded Chromedriver version
CHROMEDRIVER_VERSION="114.0.5735.90"
echo "Using hardcoded Chromedriver version: $CHROMEDRIVER_VERSION"

echo "Installing chromedriver from https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
wget -q https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

echo "Chrome and Chromedriver setup complete."
