FROM phusion/baseimage:resolute

#RUN apt-get update -y && apt-get install -y software-properties-common
RUN apt-get update && apt-get install -y nginx-full

RUN apt-get install -y python3 python3-venv libaugeas0
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip && /opt/certbot/bin/pip install certbot certbot-nginx
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

RUN mkdir /etc/service/nginx
COPY start_nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

RUN echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | tee -a /etc/crontab

RUN apt-get clean && /opt/certbot/bin/pip cache purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/pip/*

EXPOSE 80 443

CMD ["/sbin/my_init"]
