FROM alpine:3.19


RUN ["apk", "add", "--no-cache", "php83-phar", "php83-mysqli", "php83-fpm", "php83-iconv", "fcgi"]

WORKDIR /srv/www/wordpress

COPY --chmod=744 ./wordpress-entrypoint.sh /usr/local/bin

EXPOSE 9000

ENV SCRIPT_NAME=/ping
ENV SCRIPT_FILENAME=/ping
ENV REQUEST_METHOD=GET

HEALTHCHECK --interval=10s --timeout=1s --retries=3 --start-period=30s \
    CMD cgi-fcgi -bind -connect 127.0.0.1:9000 ping | grep -q pong; if [ $? -eq 0 ]; then exit 0; else exit 1; fi

ENTRYPOINT ["wordpress-entrypoint.sh"]

CMD ["php-fpm83", "-F"]
