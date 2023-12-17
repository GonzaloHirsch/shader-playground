FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install the x server
RUN apt-get update && \
    apt-get install -y git python3 python3-pip xvfb xorg-dev cmake ffmpeg qt5-qmake build-essential python3-pyqt5 && \
    apt-get clean

# Install the dependencies
RUN pip3 install vispy watchdog glfw Pillow imageio

# Set the display variable, for the virtual buffer afterwards
ENV DISPLAY=:1

# Get the repo for the libraries
RUN git clone https://github.com/GonzaloHirsch/shadertoy-to-video.git

# Get the entrypoint file
COPY entrypoint.sh entrypoint.sh

# Add enough permissions to run the script
RUN chmod +x entrypoint.sh

CMD ./entrypoint.sh
