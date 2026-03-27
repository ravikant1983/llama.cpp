# ---------- Stage 1: Build ----------
FROM ubuntu:22.04 AS builder

WORKDIR /app

# Install only required packages (NO upgrade)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy only source first (better caching)
COPY llama.cpp /app/llama.cpp

WORKDIR /app/llama.cpp

# Build using CMake (faster & correct)
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --config Release -j$(nproc)

# ---------- Stage 2: Runtime ----------
FROM ubuntu:22.04

WORKDIR /app

# Only runtime deps (very minimal)
RUN apt-get update && apt-get install -y \
    libgomp1 \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled binaries only (small + fast)
COPY --from=builder /app/llama.cpp/build /app/llama.cpp/build
#COPY llama.cpp/models /app/llama.cpp/models


RUN mkdir -p /app/llama.cpp/models && \
    wget --quiet --show-progress --content-disposition \
    "https://huggingface.co" \
    -o /app/llama.cpp/models/tinyllama.gguf


COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENV LD_LIBRARY_PATH=/app/llama.cpp/build/lib:$LD_LIBRARY_PATH

CMD ["/app/start.sh"]
