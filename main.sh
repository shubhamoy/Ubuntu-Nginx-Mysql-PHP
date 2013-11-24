#!/bin/bash
echo "*********************************************"
echo " PHP + MySQL + nGinx :: Installation Script"
echo "*********************************************"

if sudo apt-get -y install python-software-properties && sudo add-apt-repository -y ppa:nginx/stable && echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list  && sudo apt-get update && sudo apt-get -y install nginx && sudo service nginx start
then
  nginx_info="nGinx Stable Version Installed and is up running!!"
else
  nginx_info="Problem Installing nGinx"
fi

echo "************************************"
echo "Changing nGinx Server Root Directory"
echo "************************************"
if sed -i 's/root \/usr\/share\/nginx\/html;/root \/home\/www;/g' /etc/nginx/sites-available/default && sed -i 's/index index.html index.htm;/index index.html index.htm index.php;/g' /etc/nginx/sites-available/default 
then
  nginx_dir="nGinx Default Server Directory Changed to /home/www"
else
  nginx_dir="Couldn't Change nGinx Default Server Directory"
fi

echo "**************"
echo "Installing PHP"
echo "**************"
if add-apt-repository -y ppa:ondrej/php5 && apt-get -y update && apt-get install -y php5-fpm php5-mcrypt php5-cli php5-dev php-pear
then
  php_info="PHP Installed"
else
  php_info="Not able to Install PHP"
fi

#Database Install
echo "Which database engine do you want to Install? Type mysql for MySQL and mongo for MongoDB: "
read input
if [ "$input" == "mysql" ];
then
  printf "\nMySQL is selected and Installing.\n\n"
  sleep 0.9
  mysql_info="MySQL is installed with empty root password. You have to set it manually"
  export DEBIAN_FRONTEND=noninteractive
  apt-get -q -y install mysql-server mysql-client php5-mysql
elif [ "$input" == "mongo" ];
then
  printf "\n MongoDB Selected.\n\n"  
  apt-get -q -y install mongodb-10gen
  pecl install mongo
  echo extension=mongo.so>>/etc/php5/fpm/php.ini
fi

#Uncomment Few Lines from Virtual Host
if wget "https://raw.github.com/AbhishekGahlot/Ubuntu-Nginx-Mysql-PHP/master/regex_abhishek.py" && python regex_abhishek.py && service nginx restart && mkdir /home/www
then
	final_info="PHP is now working with nGinx. Create php file in /home/www and execute in browser"
	rm regex_abhishek.py
else
	final_info="Problem fetching file, You will have to configure virtual host manually"
fi

echo $nginx_info && echo $nginx_dir && echo $mysql_info && echo $php_info && echo $final_info
