# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:21c60b5442f0adf49821a3c7d1c30ff0c3c13586547b06dadc32c78613df4673 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e5cd2fd57ba08b39e49ed6a02d2192a11247600b7f2d4d8b79911d9607b789bf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
