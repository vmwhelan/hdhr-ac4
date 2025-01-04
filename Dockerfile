FROM node:lts

WORKDIR /home

COPY package.json ./
RUN yarn install --production
COPY index.js ./
COPY run.sh ./

EXPOSE 80
EXPOSE 5004

CMD ["bash", "run.sh"]
