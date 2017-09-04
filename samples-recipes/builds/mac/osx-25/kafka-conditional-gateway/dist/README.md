# Event Dispatcher & Router 

## Summary
Kafka based event dispatcher that conditionally dispatches events to various Kafka handlers based on content.

## Pre-requisites

Intall Kafka 
Follow install instructions from https://kafka.apache.org/quickstart

Start kafka zookeeper
>bin/zookeeper-server-start.sh config/zookeeper.properties

Start kafka server
>bin/kafka-server-start.sh config/server.properties

Create kafka topic
>bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic users

Create kafka producer
>bin/kafka-console-producer.sh --broker-list localhost:9092 --topic users


### Give the recipe a spin !
1. Download and run the Mashling : kafka-conditional-gateway 
2. To test if it runs, publish this sample message via the Kafka producer
```json
{  
   "id":15,
   "country":"USA",
   "category":{  
      "id":0,
      "name":"string"
   },
   "name":"doggie",
   "photoUrls":[  
      "string"
   ],
   "tags":[  
      {  
         "id":0,
         "name":"string"
      }
   ],
   "status":"available"
}
```
3. That's it !
