sudo docker run -d \
	--name some-mysql \
	--restart always \
	-e MYSQL_ROOT_PASSWORD=exemplosenha123 \
	-v /custom/mysql_data:/var/lib/mysql \
	-p 3306:3306 \
	mysql
