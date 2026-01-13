# Use 3.11 for maximum compatibility with LIMS libraries
FROM python:3.11-slim

# Install ONLY the essential lab graphics libraries (skips the 'fluff')
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcairo2-dev \
    pkg-config \
    gcc \
    g++ \
    python3-dev \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip first
RUN pip install --upgrade pip

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your LIMS code
COPY . .

# IMPORTANT: Adjust 'main:app' if your entry file is named differently
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
