# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install necessary packages and RabbitMQ
RUN apt-get update && \
    apt-get install -y gnupg2 wget curl && \
    curl -fsSL https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - && \
    echo "deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-server/deb/debian buster main" | tee /etc/apt/sources.list.d/rabbitmq.list && \
    apt-get update && \
    apt-get install -y rabbitmq-server || (cat /var/log/apt/term.log && cat /var/log/apt/history.log && exit 1) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Create and activate virtual environment, and install dependencies
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Expose necessary ports
EXPOSE 5672 15672 80

# Command to start RabbitMQ server
CMD ["rabbitmq-server"]
