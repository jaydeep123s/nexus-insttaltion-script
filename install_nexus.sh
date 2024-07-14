#!/bin/bash

# Function to install Nexus
install_nexus() {
  NEXUS_VERSION="3.70.1-02"
  JAVA_VERSION="8"

  # Check if Java 8 is installed
  if ! java -version 2>&1 | grep -q "1.${JAVA_VERSION}"; then
    echo "Java ${JAVA_VERSION} is not installed. Installing..."
    sudo apt update
    sudo apt install -y openjdk-${JAVA_VERSION}-jdk
  fi

  # Download Nexus tar.gz file
  wget -O nexus.tar.gz "https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz"

  # Extract Nexus tar.gz file
  tar -xf nexus.tar.gz

  # Rename extracted directory
  mv nexus-${NEXUS_VERSION} nexus

  # Remove tar.gz file
  rm nexus.tar.gz

  # Move Nexus directory to /opt (requires sudo)
  sudo mv nexus /opt/nexus

  # Configure Nexus to run as a service (requires sudo)
  cd /opt/nexus/bin
  sudo ./nexus start

  # Check Nexus status (requires sudo)
  echo "Waiting for Nexus to start..."
  sleep 30
  sudo ./nexus status

  # Provide information for accessing Nexus
  echo "Nexus installation completed."
  echo "You can access Nexus at http://localhost:8081/"
  echo "Login with default credentials (admin/admin123)."

  # Clean up downloaded files
  cleanup
}

# Function to clean up downloaded files
cleanup() {
  echo "Cleaning up downloaded Nexus files..."
  rm -rf /opt/nexus
}

# Call function to install Nexus
install_nexus

