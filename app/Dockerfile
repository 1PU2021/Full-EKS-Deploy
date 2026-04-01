FROM node:22-alpine

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY app.js ./

EXPOSE 3000

USER node

CMD ["node", "app.js"]