FROM node:alpine AS builder

WORKDIR /enad-frontend

COPY . .

RUN npm install && \
    npm run build

FROM nginx:alpine

COPY --from=builder /app/dist/* /usr/share/nginx/html/
