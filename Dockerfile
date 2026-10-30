FROM node:24.22.2 AS build

ARG npm_config_registry

WORKDIR /src

COPY . ./

RUN npm ci &&\
    npm run build:docs

FROM gcr.io/distroless/nodejs24

USER 65534
COPY --from=build --chown=65534 /src /app

WORKDIR /app

EXPOSE 8080

CMD ["node_modules/.bin/http-server", "-p 8080", "./dist/docs"]
