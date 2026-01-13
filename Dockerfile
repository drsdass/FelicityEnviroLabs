# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Install system dependencies for Cairo (Graphics) and PDF generation
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    pkg-config \
    python3-dev \
    gcc \
    g++ \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Set environment variables for production
ENV PORT=10000

# Start the application (Standard for FastAPI/Felicity)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
