# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 wget curl lsb-release && \
    echo "deb http://deb.debian.org/debian buster main" > /etc/apt/sources.list && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Erlang repository and install Erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb && \
    rm erlang-solutions_2.0_all.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends esl-erlang && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add RabbitMQ repository and its key
RUN curl -fsSL https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ bionic main" | tee /etc/apt/sources.list.d/rabbitmq.list

# Install RabbitMQ
RUN apt-get update && \
    apt-get install -y --no-install-recommends rabbitmq-server && \
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
