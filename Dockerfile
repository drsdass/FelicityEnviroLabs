# Alpine is much smaller and faster for Render Free Tier
FROM python:3.11-alpine

# Install the absolute bare minimum for LIMS graphics
RUN apk add --no-cache \
    gcc \
    musl-dev \
    python3-dev \
    cairo-dev \
    pango-dev \
    g++ \
    pkgconfig \
    jpeg-dev \
    zlib-dev

WORKDIR /app

# Step-by-step install to avoid memory spikes
RUN pip install --upgrade pip
COPY requirements.txt .

# Use --prefer-binary to stop Render from trying to 'compile' heavy code
RUN pip install --no-cache-dir --prefer-binary -r requirements.txt

COPY . .

ENV PORT=10000
# IMPORTANT: Double check if your file is named main.py or app.py
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
