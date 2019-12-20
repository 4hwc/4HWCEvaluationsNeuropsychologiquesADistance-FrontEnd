FROM node:12.14.0-alpine3.9 as builder
COPY package.json ./
RUN yarn install && mkdir /enad-frontend && mv ./node_modules ./enad-frontend
WORKDIR /enad-frontend
COPY . .
RUN yarn run build --prod --build-optimizer
FROM nginx:1.16-alpine
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
                                  
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /enad-frontend/dist /usr/share/nginx/html
COPY --from=builder /enad-frontend/entrypoint.sh /usr/share/nginx/
RUN chmod +x /usr/share/nginx/entrypoint.sh
CMD ["/bin/sh", "/usr/share/nginx/entrypoint.sh"]
