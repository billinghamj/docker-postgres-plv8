FROM postgres:11.7

ENV PLV8_VERSION=v2.3.11 \
    PLV8_SHASUM="3ed3d5dd9002127d0980ea4c185300cda0bd5b05f97d65b069c81cca6e08839d  v2.3.11.tar.gz"

RUN buildDependencies="build-essential \
    ca-certificates \
    curl \
    git-core \
    python \
    pkg-config \
    g++ \
    postgresql-server-dev-$PG_MAJOR" \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${buildDependencies} libc++-dev \
  && mkdir -p /tmp/build \
  && curl -o /tmp/build/${PLV8_VERSION}.tar.gz -SL "https://github.com/plv8/plv8/archive/$PLV8_VERSION.tar.gz" \
  && cd /tmp/build \
  && echo ${PLV8_SHASUM} | sha256sum -c \
  && tar -xzf /tmp/build/${PLV8_VERSION}.tar.gz -C /tmp/build/ \
  && cd /tmp/build/plv8-${PLV8_VERSION#?} \
  && make \
  && make install \
  && strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8-2.3.11.so \ 
  && cd / \
  && apt-get clean \
  && apt-get remove -y ${buildDependencies} \
  && apt-get autoremove -y \
  && rm -rf /tmp/build /var/lib/apt/lists/*
