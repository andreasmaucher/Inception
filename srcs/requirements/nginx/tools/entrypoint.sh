#!/bin/sh

# Generate SSL certificate
/generate-ssl.sh

# Start NGINX in foreground
exec nginx -g "daemon off;"