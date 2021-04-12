FROM debian:stretch
MAINTAINER Y.Nunung Pamungkas Jayuda<nunung.pamungkas@vneu.co.id>

ENV METEORD_DIR /opt/meteord
RUN mkdir -p $METEORD_DIR/lib
COPY scripts/lib/* $METEORD_DIR/lib

RUN bash $METEORD_DIR/lib/install_base.sh

ARG NODE_VERSION
ENV NODE_VERSION ${NODE_VERSION:-12.20.0}
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-12.20.0}

RUN bash $METEORD_DIR/lib/install_node.sh
RUN bash $METEORD_DIR/lib/install_meteor.sh
RUN bash $METEORD_DIR/lib/cleanup.sh

RUN apt-get install -y tzdata
RUN echo "Asia/Jakarta" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

COPY scripts/run_app.sh $METEORD_DIR

EXPOSE 80
RUN chmod +x $METEORD_DIR/run_app.sh
ENTRYPOINT exec $METEORD_DIR/run_app.sh
