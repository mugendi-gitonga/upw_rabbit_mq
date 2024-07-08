import pika
import time
import json

def callback(ch, method, properties, body):
    data = json.loads(body)
    print(f" [X] Received {data}")
    # Simulate a long-running task
    time.sleep(body.count(b'.'))
    print(" [x] Done")

    # Send acknowledgment to RabbitMQ that the message has been processed
    ch.basic_ack(delivery_tag=method.delivery_tag)

def start_worker():
    # Establish a connection to RabbitMQ
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()

    # Declare a queue
    channel.queue_declare(queue='task_queue', durable=True)

    # Only fetch one message at a time
    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue='task_queue', on_message_callback=callback)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

if __name__ == "__main__":
    start_worker()
