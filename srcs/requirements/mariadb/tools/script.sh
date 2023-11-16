#!/bin/sh

#echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';" >> db1.sql
#echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> db1.sql
#echo "DELETE FROM mysql.user WHERE User='';" >> db1.sql
#echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';" >> db1.sql
#echo "FLUSH PRIVILEGES;" >> db1.sql

mysql_install_db

/etc/init.d/mysql start

if [ -d "/var/lib/mysql/$MYSQL_DB" ]
then 

	echo "Database already exists"
else

while ! mysqladmin ping --silent; do
    sleep 1
done
mysql_secure_installation << _EOF_

Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DB; GRANT ALL ON $MYSQL_DB.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

fi

/etc/init.d/mysql stop

exec "$@"