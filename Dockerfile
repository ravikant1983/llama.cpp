# ---------- Stage 1: Build ----------
FROM ubuntu:22.04 AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y build-essential cmake git curl && rm -rf /var/lib/apt/lists/*

COPY llama.cpp /app/llama.cpp
WORKDIR /app/llama.cpp
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release -j$(nproc)

# ---------- Stage 2: Runtime ----------
FROM ubuntu:22.04
WORKDIR /app

RUN apt-get update && apt-get install -y libgomp1 curl && rm -rf /var/lib/apt/lists/*

# Copy binaries from Stage 1
COPY --from=builder /app/llama.cpp/build /app/llama.cpp/build

# FIXED: Correct URL for GitHub Action to download the 638MB model
#RUN mkdir -p /app/llama.cpp/models 
#COPY ./llama.cpp/models/ChatWithRavikant.gguf /app/llama.cpp/models/


COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV LD_LIBRARY_PATH=/app/llama.cpp/build/lib:$LD_LIBRARY_PATH
CMD ["/app/start.sh"]

