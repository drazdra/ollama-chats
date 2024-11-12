FROM public.ecr.aws/nginx/nginx:stable-alpine
RUN mkdir -p /var/www/html
COPY index.html /var/www/html/
COPY nginx-ollama.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
