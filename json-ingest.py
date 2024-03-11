from elasticsearch import Elasticsearch
import json

# Calling environmental variables
ELASTIC_CLOUD_ID = os.environ.get('ELASTIC_CLOUD_ID')
ELASTIC_USERNAME = os.environ.get('ELASTIC_USERNAME')
ELASTIC_PASSWORD = os.environ.get('ELASTIC_PASSWORD')
INDEX_NAME = os.environ.get('INDEX_NAME')
JSON_FILE_PATH = os.environ.get('FILE_PATH')  # Reading the JSON file path from an environment variable

# Connect to Elastic
def connect_to_elasticsearch(cloud_id, username, password):
    es = Elasticsearch(
        cloud_id=cloud_id,
        basic_auth=(username, password)
    )
    return es

# Index JSON file
def index_json_file(es, index_name, json_file_path):
    with open(json_file_path, 'r') as file:
        data = json.load(file)
        if isinstance(data, list):  # Check if JSON is an array of objects
            for item in data:
                es.index(index=index_name, document=item)
        else:
            es.index(index=index_name, document=data)

if __name__ == "__main__":
    es = connect_to_elasticsearch(ELASTIC_CLOUD_ID, ELASTIC_USERNAME, ELASTIC_PASSWORD)
    index_json_file(es, INDEX_NAME, JSON_FILE_PATH)
    print(f"Data from {FILE_PATH} has been indexed into {INDEX_NAME}.")
