FROM node:lts

# Install Intel Quick Sync Video (QSV) libraries inside the container
RUN apt-get update && \
    apt-get install -y \
    intel-media-va-driver-non-free \
    va-driver-all \
    libmfx1 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /home

# Copy the package.json and install dependencies
COPY package.json ./
RUN yarn install --production

# Copy the main application files
COPY index.js ./
COPY run.sh ./

# Expose necessary ports
EXPOSE 80
EXPOSE 5004

# Command to start the app
CMD ["bash", "run.sh"]
