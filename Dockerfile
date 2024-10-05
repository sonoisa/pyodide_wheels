FROM node:20.11-bookworm-slim AS node-image
FROM python:3.12.1-slim-bookworm

# Requirements for building packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
        bzip2 ccache f2c g++ gfortran git make \
        patch pkg-config swig unzip wget xz-utils \
        autoconf autotools-dev automake texinfo dejagnu \
        build-essential libtool libltdl-dev \
        gnupg2 libdbus-glib-1-2 sudo sqlite3 \
        ninja-build jq xxd \
  && rm -rf /var/lib/apt/lists/*

# Normally, it is a bad idea to install rustup and cargo in
# system directories (it should not be shared between users),
# but this docker image is only for building packages, so I hope it is ok.
RUN wget -q -O - https://sh.rustup.rs | \
    RUSTUP_HOME=/usr CARGO_HOME=/usr sh -s -- -y --profile minimal --no-modify-path

# download the latest nightly release of Rust and set it as default toolchain
RUN rustup default nightly
RUN rustup target add wasm32-unknown-emscripten

# install autoconf 2.71, required by upstream libffi
RUN wget https://mirrors.sarata.com/gnu/autoconf/autoconf-2.71.tar.xz \
    && tar -xf autoconf-2.71.tar.xz \
    && cd autoconf-2.71 \
    && ./configure \
    && make install \
    && cp /usr/local/bin/autoconf /usr/bin/autoconf \
    && rm -rf autoconf-2.71

ADD requirements.txt /

WORKDIR /

RUN pip3 --no-cache-dir install -r requirements.txt \
    && rm -rf requirements.txt

COPY --from=node-image /usr/local/bin/node /usr/local/bin/
COPY --from=node-image /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN npm install -g \
  jsdoc \
  prettier \
  rollup \
  rollup-plugin-terser

RUN pip3 --no-cache-dir install \
  pyodide-build \
  cython

RUN git clone https://github.com/emscripten-core/emsdk.git && \
  cd emsdk && \
  PYODIDE_EMSCRIPTEN_VERSION=$(pyodide config get emscripten_version) && \
  ./emsdk install ${PYODIDE_EMSCRIPTEN_VERSION} && \
  ./emsdk activate ${PYODIDE_EMSCRIPTEN_VERSION}

ADD build_whls.sh /src/


CMD ["/bin/bash"]
WORKDIR /src