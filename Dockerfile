# syntax=docker/dockerfile:1
# Use a build argument to easily switch Python versions
ARG PYTHON_VERSION=3.14
FROM python:${PYTHON_VERSION}-slim AS base

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Prevent Python from buffering stdout and stderr (better logging)
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Create a non-privileged user to run the app
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Install system dependencies (only what's needed for pip builds)
RUN apt update && \
    apt install -y --no-install-recommends gcc python3-dev && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies using cache mounts for faster rebuilds
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install --no-cache-dir -r requirements.txt

# Switch to the non-privileged user
USER appuser

# Copy application source code
COPY . .

# Set default log level
ENV LOGLEVEL=WARNING

# Expose the port that Gunicorn will listen on
EXPOSE 5000

# Run the Gunicorn app
CMD ["gunicorn", "-c", "gunicorn_config.py", "app:app"]
