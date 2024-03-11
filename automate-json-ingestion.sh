#!/bin/bash

# Prompting for user inputs
read -p "Enter your Elasticsearch Cloud ID: " cloud_id
read -p "Enter your Elasticsearch Username: " username
read -sp "Enter your Elasticsearch Password: " password  # The -s flag hides password input
echo  # Add a newline since -s suppresses the newline after input
read -p "Enter the Index Name: " index_name
read -p "Enter the path to your JSON file: " json_file_path

# Exporting the inputs as environment variables
export ELASTIC_CLOUD_ID="$cloud_id"
export ELASTIC_USERNAME="$username"
export ELASTIC_PASSWORD="$password"
export INDEX_NAME="$index_name"
export JSON_FILE_PATH="$json_file_path"

# Echo back the set variables for confirmation (excluding password for security)
echo "Elasticsearch Cloud ID: $ELASTIC_CLOUD_ID"
echo "Elasticsearch Username: $ELASTIC_USERNAME"
echo "Index Name: $INDEX_NAME"
echo "JSON File Path: $JSON_FILE_PATH"

# Running the Python script
./auto-deployments.sh
python your_python_script.py
