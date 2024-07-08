# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y gnupg wget curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add RabbitMQ signing key and repository
RUN curl -fsSL https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | gpg --dearmor -o /usr/share/keyrings/rabbitmq-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/rabbitmq-archive-keyring.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ buster main" | tee /etc/apt/sources.list.d/rabbitmq.list

# Install RabbitMQ
RUN apt-get update && \
    apt-get install -y rabbitmq-server && \
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
