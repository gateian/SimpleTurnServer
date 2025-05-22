# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Create a non-root user to run the application
RUN addgroup -g 1001 -S nodejs
RUN adduser -S turnserver -u 1001

# Change ownership of the app directory to the nodejs user
RUN chown -R turnserver:nodejs /app
USER turnserver

# Expose the TURN server port (3478) for both UDP and TCP
EXPOSE 3478/udp
EXPOSE 3478/tcp

# Expose the port range for media relay (default 49152-65535)
# Note: This is a wide range - you may want to limit it in production
EXPOSE 49152-65535/udp
EXPOSE 49152-65535/tcp

# Set environment variables with defaults
ENV TURN_PORT=3478
ENV MIN_PORT=49152
ENV MAX_PORT=65535
ENV TURN_USERNAME=myuser
ENV TURN_PASSWORD=mypassword
ENV REALM=localhost

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD netstat -an | grep :3478 || exit 1

# Start the application
CMD ["npm", "start"] 