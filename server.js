require('dotenv').config();

const Turn = require('node-turn');

const config = {
    listeningPort: parseInt(process.env.TURN_PORT) || 3478,
    listeningIps: ['0.0.0.0'],
    minPort: parseInt(process.env.MIN_PORT) || 49152,
    maxPort: parseInt(process.env.MAX_PORT) || 65535,
    authMech: 'long-term',
    credentials: {
        username: process.env.TURN_USERNAME || "myuser",
        password: process.env.TURN_PASSWORD || "mypassword"
    },
    realm: process.env.REALM || "localhost",
    debugLevel: process.env.DEBUG_LEVEL || 'ALL',
    // Enable both UDP and TCP
    enableTcp: true,
    enableUdp: true,
    // Recommended for better NAT traversal
    maxAllocateLifetime: 3600,
    maxPermissionLifetime: 300,
    // Logging options
    log: true,
    logLevel: 'INFO'
};

// If external IP is provided, add it to the configuration
if (process.env.EXTERNAL_IP) {
    config.externalIps = [process.env.EXTERNAL_IP];
    console.log(`Using external IP: ${process.env.EXTERNAL_IP}`);
} else {
    console.warn('No external IP configured - TURN server may not work correctly from outside the network');
}

const server = new Turn(config);

// Start the server
try {
    server.start();
    console.log('=== TURN Server Configuration ===');
    console.log(`Listening on: ${config.listeningIps.join(', ')}:${config.listeningPort}`);
    console.log(`External IP: ${config.externalIps ? config.externalIps[0] : 'Not configured'}`);
    console.log(`Realm: ${config.realm}`);
    console.log(`Port range: ${config.minPort}-${config.maxPort}`);
    console.log(`Debug level: ${config.debugLevel}`);
    console.log(`TCP enabled: ${config.enableTcp}`);
    console.log(`UDP enabled: ${config.enableUdp}`);
    console.log(`Credentials: ${config.credentials.username}:${config.credentials.password}`);
    console.log('==============================');
} catch (error) {
    console.error('Failed to start TURN server:', error);
    process.exit(1);
}

// Handle process termination
process.on('SIGTERM', () => {
    console.log('Received SIGTERM. Shutting down TURN server...');
    try {
        server.stop();
        process.exit(0);
    } catch (error) {
        console.error('Error while shutting down:', error);
        process.exit(1);
    }
}); 