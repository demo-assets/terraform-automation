#!/bin/bash

# Replace your actual EC_API_KEY value here
read -p "Enter number of workshop attendees: " Attendees
read -p "Enter ECE API Key: " ECE-Key
EC_API_KEY="$ECE-Key"
for i in {1..$Attendees}; do
  curl -XPOST \
    -H 'Content-Type: application/json' \
    -H "Authorization: ApiKey $EC_API_KEY" \
    "https://api.elastic-cloud.com/api/v1/deployments" \
    -d '
    {
      "resources": {
        "elasticsearch": [
          {
            "region": "gcp-us-central1", 
            "ref_id": "main-elasticsearch",
            "plan": {
              "cluster_topology": [
                {
                  "zone_count": 1, 
                  "elasticsearch": {
                    "node_attributes": {
                      "data": "hot"
                    }
                  },
                  "instance_configuration_id": "gcp.es.datahot.n2.68x16x45", 
                  "node_roles": [
                    "master",
                    "ingest",
                    "transform",
                    "data_hot",
                    "remote_cluster_client",
                    "data_content"
                  ],
                  "id": "hot_content",
                  "size": {
                    "value": 4096, 
                    "resource": "memory"
                  }
                },
                {
                  "zone_count": 1,
                  "elasticsearch": {
                    "node_attributes": {
                      "data": "warm"
                    }
                  },
                  "instance_configuration_id": "gcp.es.datawarm.n2.68x10x190",
                  "node_roles": [
                    "data_warm",
                    "remote_cluster_client"
                  ],
                  "id": "warm",
                  "size": {
                    "resource": "memory",
                    "value": 0
                  }
                },
                {
                  "zone_count": 1,
                  "elasticsearch": {
                    "node_attributes": {
                      "data": "cold"
                    }
                  },
                  "instance_configuration_id": "gcp.es.datacold.n2.68x10x190",
                  "node_roles": [
                    "data_cold",
                    "remote_cluster_client"
                  ],
                  "id": "cold",
                  "size": {
                    "resource": "memory",
                    "value": 0
                  }
                },
                {
                  "zone_count": 1,
                  "elasticsearch": {
                    "node_attributes": {
                      "data": "frozen"
                    }
                  },
                  "instance_configuration_id": "gcp.es.datafrozen.n2.68x10x95",
                  "node_roles": [
                    "data_frozen"
                  ],
                  "id": "frozen",
                  "size": {
                    "resource": "memory",
                    "value": 0
                  }
                },
                {
                  "zone_count": 3,
                  "instance_configuration_id": "gcp.es.master.n2.68x32x45",
                  "node_roles": [
                    "master",
                    "remote_cluster_client"
                  ],
                  "id": "master",
                  "size": {
                    "resource": "memory",
                    "value": 0
                  }
                },
                {
                  "zone_count": 2,
                  "instance_configuration_id": "gcp.es.coordinating.n2.68x16x45",
                  "node_roles": [
                    "ingest",
                    "remote_cluster_client"
                  ],
                  "id": "coordinating",
                  "size": {
                    "resource": "memory",
                    "value": 0
                  }
                },
                {
                  "zone_count": 1,
                  "instance_configuration_id": "gcp.es.ml.n2.68x32x45",
                  "node_roles": [
                    "ml",
                    "remote_cluster_client"
                  ],
                  "id": "ml",
                  "size": {
                    "resource": "memory",
                    "value": 4096
                  }
                }
              ],
              "elasticsearch": {
                "version": "8.12.2",
                "enabled_built_in_plugins": []
              },
              "deployment_template": {
                "id": "gcp-general-purpose-v3" 
              }
            }
          }
        ],
        "kibana": [
          {
            "elasticsearch_cluster_ref_id": "main-elasticsearch",
            "region": "gcp-us-central1",
            "plan": {
              "cluster_topology": [
                {
                  "instance_configuration_id": "gcp.kibana.n2.68x32x45",
                  "zone_count": 1, 
                  "size": {
                    "resource": "memory",
                    "value": 1024 
                  }
                }
              ],
              "kibana": {
                "version": "8.12.2"
              }
            },
            "ref_id": "main-kibana"
          }
        ],
        "integrations_server": [
          {
            "elasticsearch_cluster_ref_id": "main-elasticsearch",
            "region": "gcp-us-central1",
            "plan": {
              "cluster_topology": [
                {
                  "instance_configuration_id": "gcp.integrationsserver.n2.68x32x45",
                  "zone_count": 1, 
                  "size": {
                    "resource": "memory",
                    "value": 1024 
                  }
                }
              ],
              "integrations_server": {
                "version": "8.12.2"
              }
            },
            "ref_id": "main-integrations_server"
          }
        ],
        "enterprise_search": [
          {
            "elasticsearch_cluster_ref_id": "main-elasticsearch",
            "region": "gcp-us-central1",
            "plan": {
              "cluster_topology": [
                {
                  "node_type": {
                    "connector": true,
                    "appserver": true,
                    "worker": true
                  },
                  "instance_configuration_id": "gcp.enterprisesearch.n2.68x32x45",
                  "zone_count": 1, 
                  "size": {
                    "resource": "memory",
                    "value": 2048 
                  }
                }
              ],
              "enterprise_search": {
                "version": "8.12.2"
              }
            },
            "ref_id": "main-enterprise_search"
          }
        ]
      },
      "name": "my-first-api-deployment"
    }
    '
  echo "Curl call number $i completed"
  sleep 10 # This will pause for 10 second between each request to allow cloud instance to process without any issues.
done
