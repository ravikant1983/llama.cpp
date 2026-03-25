FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY llama.cpp /app/llama.cpp
COPY llama.cpp/models /app/llama.cpp/models

WORKDIR /app/llama.cpp

RUN cmake -B build
RUN cmake --build build



COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV LD_LIBRARY_PATH=/app/llama.cpp/build/lib:$LD_LIBRARY_PATH

CMD ["/app/start.sh"]
