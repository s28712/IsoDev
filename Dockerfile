FROM node

ARG cmd=""
ENV arg=$cmd

WORKDIR /app

CMD npm $arg