# We are moving from 3.13 to 3.11 for better stability with LIMS plugins
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    pkg-config \
    python3-dev \
    gcc \
    g++ \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip to ensure it can find the right packages
RUN pip install --upgrade pip

COPY requirements.txt .
# Adding --no-cache-dir saves space on Render
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=10000
# Ensure your start command matches your LIMS (e.g., main:app or app.main:app)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
