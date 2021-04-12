FROM debian:stretch
MAINTAINER Y.Nunung Pamungkas Jayuda<nunung.pamungkas@vneu.co.id>

ENV METEORD_DIR /opt/meteord
COPY scripts $METEORD_DIR

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-12.22.1}
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-12.22.1}

RUN bash $METEORD_DIR/lib/install_base.sh
RUN bash $METEORD_DIR/lib/install_node.sh
RUN bash $METEORD_DIR/lib/cleanup.sh

RUN apt-get install -y tzdata
RUN echo "Asia/Jakarta" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

EXPOSE 80
RUN chmod +x $METEORD_DIR/run_app.sh
ENTRYPOINT exec $METEORD_DIR/run_app.sh
