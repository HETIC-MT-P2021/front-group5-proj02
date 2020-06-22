FROM node:10-alpine as builder

COPY package.json package-lock.json ./

RUN npm install && mkdir /front-app && mv ./node_modules ./front-app

WORKDIR /front-app

COPY . .

RUN npm run build

FROM nginx:alpine

#!/bin/sh

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /front-app/build /usr/share/nginx/html

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]