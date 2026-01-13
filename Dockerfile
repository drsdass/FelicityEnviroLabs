# STAGE 1: The Builder (Where the heavy lifting happens)
FROM python:3.11-slim as builder

# Install build tools and graphics libraries
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    libcairo2-dev \
    pkg-config \
    python3-dev \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Step-by-step install to avoid memory spikes
RUN pip install --upgrade pip
COPY requirements.txt .

# Use --prefer-binary to pull pre-built versions of Pandas/Cryptography
RUN pip install --user --no-cache-dir --prefer-binary -r requirements.txt

# STAGE 2: The Final Runner (This stays under the RAM limit)
FROM python:3.11-slim

# Install ONLY the graphics libraries needed for PDFs
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the installed libraries from the builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the app can find the libraries
ENV PATH=/root/.local/bin:$PATH
ENV PORT=10000

# Start command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
