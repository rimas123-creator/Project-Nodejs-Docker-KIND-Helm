FROM node:alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:alpine 

RUN addgroup -S helm-app-group && adduser -S helm-app-user -G helm-app-group

COPY --from=build /app ./

USER helm-app-user

CMD ["npm", "start"]