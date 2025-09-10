/*
DOCKER COMPOSE

tool to define and run multi-container applications
all services (containers), networks, volumes are described in the .yml file
"docker compose up" to start the infrastructure

Image: Blueprint for a container
Container: Running instance of an image
Docker Volumes: special directories on the host (if a container is deleted, the data in the volume remains)

-> with compose images are run and built according to .yml file

*/

/*
MARIA DB

drop-in replacement for MySQL and used as a database for wordpress

mariadb-client provides the mysql command

*/

/*
COMMANDS

make all
make clean (always needs to be done after a change before redoing make all)

make ps (see all services running)
*/

/*
How it works:
1. Client requests https://yourdomain.com
2. Nginx receives request on port 443
3. SSL encrypts the connection
4. Static files served directly by Nginx
5. PHP files forwarded to WordPress container
6. WordPress processes PHP and returns HTML
7. Nginx sends response back to client
*/