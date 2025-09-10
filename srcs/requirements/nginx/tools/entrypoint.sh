#!/bin/sh

# Generate SSL certificate
/generate-ssl.sh

# Start NGINX in foreground (daemon off means foreground mode)
# exec replaces the shell process with nginx, making nginx the main process (PID 1)
# -> Docker now monitors nginx directly instead of the shell
# -> This ensures proper signal handling and graceful shutdown
# -> Container stops cleanly when nginx receives SIGTERM
# Single command execution so no infinite loop possible
exec nginx -g "daemon off;"
# exec is a system call that replaces the current process, all FDs and envs are preserved
# exec doesn't start a new process, but it transforms the existing process from a shell into nginx