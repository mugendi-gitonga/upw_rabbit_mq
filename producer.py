import pika
import uuid
import datetime
import json
import os

RABBITMQ_HOST = os.getenv('RABBITMQ_HOST')

def send_task(message):
    # Establish a connection to RabbitMQ
    connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=os.getenv('RABBITMQ_HOST'),
        port=int(os.getenv('RABBITMQ_PORT')),
        credentials=pika.PlainCredentials(
            username=os.getenv('RABBITMQ_USER'),
            password=os.getenv('RABBITMQ_PASS')
        )
    ))
    channel = connection.channel()

    # Declare a queue
    channel.queue_declare(queue='task_queue', durable=True)

    # Publish to queue
    payload = json.dumps(message)
    channel.basic_publish(
        exchange='',
        routing_key='task_queue',
        body=payload,
        properties=pika.BasicProperties(
            delivery_mode=2,  # Make message persistent
        ))
    print(f" [X] Sent '{message}'")

    # Close the connection
    connection.close()

if __name__ == "__main__":
    message = {
        "message_id":uuid.uuid4().hex,
        "created_on": str(datetime.datetime.now())
    }

    send_task(message)
