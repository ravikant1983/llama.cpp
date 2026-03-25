#!/bin/bash

/app/llama.cpp/build/bin/llama-server \
  -m /app/llama.cpp/models/tinyllama.gguf \
  --host 0.0.0.0 \
  --port 8080

