# Use the Alpine Linux as the base image
FROM	debian:buster

# Install NGINX
RUN		apt-get update && \
		apt-get install -y nginx \
                openssl

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Create a self-signed SSL certificate (you can replace this with your own certificate)
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/nginx.crt \
       -keyout /etc/nginx/ssl/nginx.key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=tadiyamu/CN=tadiyamu/"
# Copy the NGINX configuration file to the container
COPY ./conf/wordpress.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

# Expose ports
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
