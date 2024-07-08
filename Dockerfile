# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg wget curl lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Erlang repository
RUN curl -fsSL https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb -o erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb && \
    rm erlang-solutions_2.0_all.deb

# Add RabbitMQ repository
RUN curl -fsSL https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/rabbitmq.list

# Install Erlang and RabbitMQ
RUN apt-get update && \
    apt-get install -y --no-install-recommends esl-erlang rabbitmq-server && \
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
