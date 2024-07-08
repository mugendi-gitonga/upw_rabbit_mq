# python-rabbitmq-docker

The main objective is to showcase how to create an application that sends and receives a message from a RabbitMQ message broker, using Docker and docker-compose tools.

## Stack

- Docker
- RabbitMQ
- Pika
- Python 3.10

## How to use

### Using Docker Compose 
You will need Docker installed to follow the next step. To create and run the image use the following command:
```bash
docker-compose up --build
```

The configuration will create a cluster with 3 containers:

- Producer container
- Consumer container
- RabbitMQ container

The Producer container is a script that aims to send messages to Message Broker.

The Consumer container is a script that aims to wait and receive messages from Message Broker.

And the RabbitMQ container is where messages flow through RabbitMQ and applications, stored inside a queue. A web browser access to the Dashboard is also provided for RabbitMQ message management and monitoring which can be accessed at `http://localhost:15672`.
