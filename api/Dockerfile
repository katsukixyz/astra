FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN yarn

COPY . .

ENV PORT=5000

EXPOSE 5000

CMD ["yarn", "start"]