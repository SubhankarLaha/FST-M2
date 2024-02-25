#build phase
FROM node:18-alpine as builder
WORKDIR /usr/app
COPY ./ ./
RUN npm install
RUN npm run build

# Run Phase
FROM node:18-alpine
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY --from=builder /usr/app/dist /usr/app
CMD ["node", "server.js"]