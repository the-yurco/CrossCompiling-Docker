# Stage 1: Build the ARM binary
FROM ubuntu AS builder

RUN apt-get update && apt-get install -y \
    gcc-aarch64-linux-gnu 
    

# Set the working directory
WORKDIR /app

# Copy your source code into the container
COPY . /app

# Cross-compile the application
RUN aarch64-linux-gnu-gcc -o hello main.c

# Stage 2: Create a minimal runtime image
FROM ubuntu AS runtime

RUN apt-get update && apt-get install -y openssh-client

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/hello /app/hello

# Specify QEMU for user emulation
CMD ["/app/hello"]

