# Define custom function directory
ARG FUNCTION_DIR="/function"

FROM node:12-buster as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

# Copy function code
RUN mkdir -p ${FUNCTION_DIR}
COPY src/* ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

RUN npm install

# Grab a fresh slim copy of the image to reduce the final size
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN /usr/bin/apt-get update && \
	/usr/bin/apt-get install -y curl && \
	curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
	/usr/bin/apt-get update && \
	/usr/bin/apt-get upgrade -y && \
	/usr/bin/apt-get install -y nodejs pulseaudio xvfb firefox ffmpeg xdotool unzip dbus-x11

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

# Copy in the built dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENTRYPOINT ["/usr/bin/npx", "aws-lambda-ric"]
CMD ["index.handler"]
