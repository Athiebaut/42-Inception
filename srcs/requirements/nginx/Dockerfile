FROM alpine:3.19

RUN ["apk", "add", "--no-cache", "nginx", "openssl"]

COPY --chmod=744 ./default.conf /etc/nginx/http.d

RUN ["mkdir", "-p", "/srv/www/wordpress"]
RUN ["addgroup", "nginx", "nobody"]
RUN ["openssl", "req", "-x509", "-newkey", "rsa:2048", "-noenc", "-subj", "/", "-days", "3650", "-keyout", "/root/key.pem", "-out", "/root/crt.pem"]

STOPSIGNAL SIGINT

EXPOSE 443

HEALTHCHECK --interval=10s --timeout=1s --retries=3 --start-period=30s \
    CMD wget -q --tries=1 --spider --no-check-certificate https://localhost:443/health; if [ $? -eq 0 ]; then exit 0; else exit 1; fi

ENTRYPOINT ["nginx"]

CMD ["-g", "daemon off;"]
