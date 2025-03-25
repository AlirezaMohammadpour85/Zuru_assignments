FROM nginx:latest
# Copy custom nginx.conf into the container
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
