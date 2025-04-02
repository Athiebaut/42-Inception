FROM alpine:3.19

RUN ["apk", "add", "--no-cache", "mariadb", "mariadb-client", "openrc"]
RUN ["mkdir", "-p", "/run/openrc/exclusive"]

RUN ["touch", "/run/openrc/softlevel"]

COPY --chmod=744 ./mariadb-entrypoint.sh /usr/local/bin

STOPSIGNAL SIGINT

EXPOSE 3306

HEALTHCHECK --interval=10s --timeout=1s --retries=3 --start-period=90s \
    CMD mysqladmin -u$DB_ROOT_USER -p$DB_ROOT_PASSWD ping 2>&1 | grep -qE "mysqld is alive"; if [ $? -eq 0 ]; then exit 0; else exit 1; fi

ENTRYPOINT ["mariadb-entrypoint.sh"]

CMD ["mariadbd-safe"]
