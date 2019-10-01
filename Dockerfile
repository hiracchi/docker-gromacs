FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/hiracchi/docker-gromacs" \
      org.label-schema.version=$VERSION \
      maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"

ARG WORKDIR="/work"


# =============================================================================
ENV LC_ALL=C LANG=C DEBIAN_FRONTEND="noninteractive" TZ=Asia/Tokyo
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    sudo locales tzdata bash \
    && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* 
RUN set -x && \
  echo "dash dash/sh boolean false" | debconf-set-selections && \
  dpkg-reconfigure dash
RUN set -x && \
  locale-gen ja_JP.UTF-8 && \
  update-locale LANG=ja_JP.UTF-8 && \
  echo "${TZ}" > /etc/timezone && \
  mv /etc/localtime /etc/localtime.orig && \
  ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata 
RUN set -x && \
  mkdir -p /etc/sudoers.d/ && \
  echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ALL && \
  chmod u+s /usr/sbin/useradd && \
  chmod u+s /usr/sbin/groupadd


# setup packages ===============================================================
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
     gromacs \
     && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# entrypoint ------------------------------------------------------------------
RUN set -x && \
  mkdir -p /work
WORKDIR /work

COPY docker-entrypoint.sh /usr/local/bin
COPY usage.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/usage.sh"]
