#!/bin/bash

# Add the Google Chrome signing key and repo
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list
apt-get update -qq
apt-get install -y google-chrome-stable

# Get the installed Chrome version
CHROME_VERSION=$(google-chrome --version)
# | grep -oP '\d+\.\d+\.\d+' | head -n1)
echo "Chrome version installed: $CHROME_VERSION"

# Get the major version of Chrome to fetch the correct Chromedriver
CHROME_MAJOR_VERSION=$(echo $CHROME_VERSION | cut -d '.' -f 1)

# Fetch the correct Chromedriver version based on Chrome major version
CHROMEDRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_MAJOR_VERSION)

if [ -z "$CHROMEDRIVER_VERSION" ]; then
    echo "No matching Chromedriver version found for Chrome $CHROME_VERSION"
    exit 1
fi

echo "Installing chromedriver https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip -d /usr/local/bin/
chmod +x /usr/local/bin/chromedriver
rm chromedriver_linux64.zip
