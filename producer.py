import pika
import uuid
import datetime
import json

def send_task(message):
    # Establish a connection to RabbitMQ
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost', 5672))
    channel = connection.channel()

    # Declare a queuez
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
