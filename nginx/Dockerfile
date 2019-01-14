FROM nginx:1.14-alpine
# COPY nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
COPY localhost.conf /etc/nginx/conf.d/localhost.conf
EXPOSE 8000