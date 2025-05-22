# Node.js TURN Server

A simple TURN server implementation using Node.js, ready for Docker deployment.

## Quick Start with Docker

### Option 1: Using Docker Compose (Recommended for Portainer)

1. Clone this repository
2. Edit the environment variables in `docker-compose.yml`:
   - Set `EXTERNAL_IP` to your server's public IP address
   - Change `TURN_USERNAME` and `TURN_PASSWORD` for security
3. Deploy:

```bash
docker-compose up -d
```

### Option 2: Building and Running with Docker

1. Build the Docker image:

```bash
docker build -t turn-server .
```

2. Run the container:

```bash
docker run -d \
  --name turn-server \
  --network host \
  -e EXTERNAL_IP=your.public.ip.here \
  -e TURN_USERNAME=myuser \
  -e TURN_PASSWORD=mypassword \
  -e REALM=localhost \
  turn-server
```

## Deployment in Portainer

### Method 1: Using Docker Compose (Recommended)

1. In Portainer, go to **Stacks** → **Add Stack**
2. Upload the `docker-compose.yml` file or copy its contents
3. **Important**: Edit these environment variables before deployment:
   - `EXTERNAL_IP`: Your server's public IP address (required for external clients)
   - `TURN_USERNAME`: Choose a secure username
   - `TURN_PASSWORD`: Choose a strong password
4. Deploy the stack

### Method 2: Using Git Repository

1. In Portainer, go to **Stacks** → **Add Stack**
2. Choose **Repository** option
3. Enter this repository URL
4. Set the stack file path to `docker-compose.yml`
5. Configure environment variables in the **Environment variables** section
6. Deploy

### Method 3: Manual Container Creation

1. Build or pull the image first
2. Create a new container with these settings:
   - **Network**: Host mode (recommended for TURN servers)
   - **Environment Variables**: Set all required variables
   - **Restart Policy**: Unless stopped

## Traditional Setup (Non-Docker)

1. Install dependencies:

```bash
npm install
```

2. Configure environment variables or modify `server.js`
3. Start the server:

```bash
npm start
```

## Configuration

### Environment Variables

| Variable        | Default    | Description                                                      |
| --------------- | ---------- | ---------------------------------------------------------------- |
| `TURN_PORT`     | 3478       | The port the TURN server listens on                              |
| `MIN_PORT`      | 49152      | Minimum port for media relay                                     |
| `MAX_PORT`      | 65535      | Maximum port for media relay                                     |
| `TURN_USERNAME` | myuser     | Username for TURN authentication                                 |
| `TURN_PASSWORD` | mypassword | Password for TURN authentication                                 |
| `REALM`         | localhost  | TURN realm (use your domain in production)                       |
| `EXTERNAL_IP`   | (none)     | **Required**: Your server's public IP address                    |
| `DEBUG_LEVEL`   | INFO       | Logging level (ALL, TRACE, DEBUG, INFO, WARN, ERROR, FATAL, OFF) |

The current configuration matches your previous coturn setup:

- Listening on all interfaces (0.0.0.0)
- Port: 3478
- Port range: 49152-65535
- Authentication: Long-term credential mechanism
- Default credentials: myuser:mypassword

## Security Notes

1. **In production, you MUST**:

   - Set a strong `TURN_PASSWORD`
   - Configure the correct `EXTERNAL_IP`
   - Use a proper `REALM` (your domain)
   - Configure your firewall to allow the TURN ports
   - Consider using SSL/TLS certificates

2. **Network Configuration**:
   - The Docker container uses host networking mode for better NAT traversal
   - Ensure ports 3478 and 49152-65535 are open in your firewall
   - For cloud deployments, configure security groups appropriately

## Usage with WebRTC

To use this TURN server with WebRTC applications, use the following configuration:

```javascript
const iceServers = [
  {
    urls: "turn:your-server-ip:3478",
    username: "myuser",
    credential: "mypassword",
  },
];
```

## Troubleshooting

### Common Issues

1. **TURN server not accessible from outside**: Make sure `EXTERNAL_IP` is set correctly
2. **Permission denied errors**: The container runs as non-root user for security
3. **Port conflicts**: Ensure ports 3478 and the relay range aren't used by other services
4. **WebRTC still failing**: Check that your firewall allows both TCP and UDP traffic

### Checking if the server is running

```bash
# Check if the port is listening
netstat -an | grep :3478

# View container logs
docker logs turn-server

# Test connectivity (replace with your server IP)
telnet your-server-ip 3478
```

## Building for Production

To deploy this in production:

1. Push your image to a registry:

```bash
docker build -t your-registry/turn-server:latest .
docker push your-registry/turn-server:latest
```

2. Update `docker-compose.yml` to use your registry image instead of building locally

3. Use Docker secrets or environment variable management for sensitive data
