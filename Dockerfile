FROM php:7.4-fpm-alpine

EXPOSE 8123
WORKDIR /var/www/html

RUN echo "<?php \$e=\$_ENV['WEB'];\$h=\$_ENV['HOSTNAME'];?>" >> index.php
RUN echo "<h1>Hello From App Version: <?php echo \$e;?></h1>" >> index.php
RUN echo "<h2>My Container is: <?php echo \$h;?></h2>" >> index.php
RUN echo "<h3>---</h3>" >> index.php

ENTRYPOINT ["php","-S","0.0.0.0:8123"]
