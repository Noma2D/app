FROM alpine:latest

RUN apt update && apt install nginx python3 pip

RUN mkdir /app
WORKDIR /app
COPY files/default.sh /etc/nginx/sites-avaible/default
COPY files/nginx.conf /etc/nginx/nginx.conf/
COPY files/snakeoil.conf /etc/nginx/snippets/snakeoil.conf
COPY files/app.pem /etc/ssl/private/app.pem
COPY files/app.key /etc/ssl/private/app.key


COPY . /app/.

RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 80 443

CMD ["python", "/app/app.py $COMPETITOR_ID"]
