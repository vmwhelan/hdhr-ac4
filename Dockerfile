FROM node:20 AS ffmpeg

WORKDIR /home

RUN apt-get install -y binutils xz-utils
RUN curl -L -o emby.deb https://github.com/MediaBrowser/Emby.Releases/releases/download/4.7.13.0/emby-server-deb_4.7.13.0_amd64.deb
RUN ar x emby.deb data.tar.xz && \
    tar xf data.tar.xz

# Set up the app and copy over ffmpeg
FROM node:20

WORKDIR /home
COPY package.json ./
RUN yarn install --production
COPY *.js ./

COPY --from=ffmpeg /home/opt/emby-server/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg /home/opt/emby-server/lib/libav*.so.* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/lib/libpostproc.so.* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/lib/libsw* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/extra/lib/libva*.so.* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/extra/lib/libdrm.so.* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/extra/lib/libmfx.so.* /usr/lib/
COPY --from=ffmpeg /home/opt/emby-server/extra/lib/libOpenCL.so.* /usr/lib/

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]
