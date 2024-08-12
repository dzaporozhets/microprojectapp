#!/bin/bash

# Add the Google Chrome signing key and repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update -qq
apt-get install -y google-chrome-stable

# Hardcoded Chrome version
CHROME_VERSION="115.0.5790.102"
echo "Using hardcoded Chrome version: $CHROME_VERSION"

# Hardcoded Chromedriver version
CHROMEDRIVER_VERSION="115.0.5790.102"
echo "Using hardcoded Chromedriver version: $CHROMEDRIVER_VERSION"

echo "Installing chromedriver https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip

