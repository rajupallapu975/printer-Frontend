# Use Ubuntu image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Download Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Enable web
RUN flutter channel stable
RUN flutter upgrade
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Get packages
RUN flutter pub get

# Build web
RUN flutter build web

# Install simple web server
RUN apt-get update && apt-get install -y python3

# Expose port
EXPOSE 10000

# Start server
CMD ["python3", "-m", "http.server", "10000", "--directory", "build/web"]
