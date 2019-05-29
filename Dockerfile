FROM ubuntu:18.04
LABEL MAINTAINER="Power Li<pccr10001@power.li>"

# install base package
RUN apt-get update && apt-get -y install cron dnsmasq python3-pip wget curl

# install doh-proxy
RUN pip3 install --prefix /usr/local doh-proxy

WORKDIR /tmp

RUN wget https://github.com/AdguardTeam/dnsproxy/releases/download/v0.14.0/dnsproxy-linux-amd64-v0.14.0.tar.gz -O dnsproxy.tar.gz && \
    tar xvf dnsproxy.tar.gz && \
    cp linux-amd64/dnsproxy /usr/local/bin/ && \
    chmod +x /usr/local/bin/dnsproxy
    
COPY cron-update-hosts /etc/cron.d/cron-update-hosts

COPY start.sh /usr/bin/start.sh

COPY update_blacklist.sh /usr/bin/update_blacklist.sh

RUN chmod 0644 /etc/cron.d/cron-update-hosts && \
    crontab /etc/cron.d/cron-update-hosts

COPY data /template

CMD /usr/bin/start.sh

EXPOSE 8080
EXPOSE 8443
EXPOSE 5353/udp
