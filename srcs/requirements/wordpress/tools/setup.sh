#!/bin/sh

php_ini_cli="/etc/php/7.3/cli/php.ini"
php_ini_fpm="/etc/php/7.3/fpm/php.ini"
php_ini_cgi="/etc/php/7.3/cgi/php.ini"

max_execution_time="300000"
max_input_time="1000000"
memory_limit="256M"
post_max_size="64M"
upload_max_size="64M"

update_php_config() {
    local php_ini="$1"
    local setting_name="$2"
    local new_value="$3"
    
    if grep -qE "^$setting_name\s*=" "$php_ini"; then
        sed -i "s/^$setting_name\s*=.*/$setting_name = $new_value/" "$php_ini"
    else
        echo "$setting_name = $new_value" >> "$php_ini"
    fi
}

if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else
	update_php_config "$php_ini_cli" "max_execution_time" "$max_execution_time"
	update_php_config "$php_ini_cli" "max_input_time" "$max_input_time"
	update_php_config "$php_ini_cli" "memory_limit" "$memory_limit"
	update_php_config "$php_ini_cli" "post_max_size" "$post_max_size"
	update_php_config "$php_ini_cli" "upload_max_size" "$upload_max_size"

	update_php_config "$php_ini_fpm" "max_execution_time" "$max_execution_time"
	update_php_config "$php_ini_fpm" "max_input_time" "$max_input_time"
	update_php_config "$php_ini_fpm" "memory_limit" "$memory_limit"
	update_php_config "$php_ini_fpm" "post_max_size" "$post_max_size"
	update_php_config "$php_ini_fpm" "upload_max_size" "$upload_max_size"

	update_php_config "$php_ini_cgi" "max_execution_time" "$max_execution_time"
	update_php_config "$php_ini_cgi" "max_input_time" "$max_input_time"
	update_php_config "$php_ini_cgi" "memory_limit" "$memory_limit"
	update_php_config "$php_ini_cgi" "post_max_size" "$post_max_size"
	update_php_config "$php_ini_cgi" "upload_max_size" "$upload_max_size"

	wp core download http://wordpress.org/latest.tar.gz \
		--allow-root
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/mariadb/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DB/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php
	
	while ! mysqladmin ping  -h"mariadb" --silent; do
    	sleep 1
	done
	
	wp core install \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email=$WP_ADMIN_EMAIL \
		--allow-root

	wp user create $WP_AUTHOR_USER $WP_AUTHOR_EMAIL \
		--role=author \
		--allow-root
	
	wp user update $WP_AUTHOR_USER \
		--user_pass=$WP_AUTHOR_PASSWORD \
		--allow-root

fi

exec "$@"