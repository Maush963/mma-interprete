FROM gcc:latest

RUN apt-get update && apt-get install -y --no-install-recommends flex bison make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN make clean && make

ENTRYPOINT ["./mma"]
CMD ["ejemplos/peleadores.mma"]
