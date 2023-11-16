# Use a base image that doesn't rely on Docker Hub, e.g., Debian Buster
FROM debian:buster

# Install MariaDB
RUN     apt-get update
RUN     apt-get upgrade
RUN     apt-get install -y mariadb-server
RUN     apt-get install -y mariadb-client

RUN     mkdir -p /var/run/mysqld && \
        chown -R mysql:mysql /var/run/mysqld && \
        chmod 777 /var/run/mysqld && \
        chown -R mysql:mysql /etc/mysql/

# Copy custom configuration file and setup SQL script
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /tmp/script.sh

RUN chmod +x /tmp/script.sh && \
    chown -R mysql:mysql /tmp/ && \
    chown -R mysql:mysql /etc/mysql

EXPOSE 3306

# Start MariaDB and run the setup SQL script during container startup
ENTRYPOINT ["sh", "/tmp/script.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]