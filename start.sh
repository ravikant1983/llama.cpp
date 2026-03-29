#!/bin/bash

/app/llama.cpp/build/bin/llama-server \
  -m /app/llama.cpp/models/Llama-3.2-3B-Instruct-Q4_K_M.gguf \
  -c 4096 \
  --host 0.0.0.0 \
  --port 8080

