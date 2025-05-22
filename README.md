# Node.js TURN Server

A simple TURN server implementation using Node.js.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Configure the server:
   - Open `server.js` and modify the configuration object to match your needs:
     - `listeningPort`: The port the TURN server will listen on (default: 3478)
     - `credentials`: Update the username and password
     - `realm`: Your domain or "localhost" for testing
     - `minPort` and `maxPort`: Port range for TURN relay

3. Start the server:
```bash
npm start
```

## Configuration

The current configuration matches your previous coturn setup:
- Listening on all interfaces (0.0.0.0)
- Port: 3478
- Port range: 49152-65535
- Authentication: Long-term credential mechanism
- Default credentials: myuser:mypassword

## Security Notes

1. In production, you should:
   - Use environment variables for sensitive data (credentials)
   - Set up proper SSL/TLS certificates
   - Configure your firewall to allow the TURN ports
   - Use a strong password
   - Set the appropriate external IP

2. Make sure to change the default credentials before deploying.

## Usage with WebRTC

To use this TURN server with WebRTC applications, use the following configuration:

```javascript
const iceServers = [{
    urls: 'turn:your-server-ip:3478',
    username: 'myuser',
    credential: 'mypassword'
}];
``` 