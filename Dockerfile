FROM node:lts
COPY package.json .
RUN npm install --production
COPY dist/ .

