FROM alpine:3

ENV WEB_API 1
ENV INTERVAL 30

RUN mkdir -p /app/cgi-bin/
WORKDIR /app

RUN apk --no-cache add \
    bash \
    busybox-extras \
    curl \
    tini && \
    chmod 755 -R /app/*

EXPOSE 5000

ENTRYPOINT ["/sbin/tini", "--"]

CMD [ "httpd", "-p", "5000", "-f", "-v", "-h", "/app/" ]

COPY cgi-bin/index.cgi /app/cgi-bin/index.cgi
COPY cgi-bin/healthz /app/cgi-bin/healthz
