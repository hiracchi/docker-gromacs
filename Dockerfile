FROM hiracchi/ubuntu-ja:18.04.1

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/hiracchi/docker-gromacs" \
      org.label-schema.version=$VERSION \
      maintainer="Toshiyuki Hirano <hiracchi@gmail.com>"


ARG WORKDIR="/work"

# ------------------------------------------------------------------------------
# setup packages
# ------------------------------------------------------------------------------
RUN set -x \
  && apt-get update \
  && apt-get install -y \
     gromacs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# entrypoint
# ------------------------------------------------------------------------------
RUN set -x \
  && mkdir -p /work
WORKDIR /work

COPY usage.sh /usr/local/bin
CMD ["/usr/local/bin/usage.sh"]
