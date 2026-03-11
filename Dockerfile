# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2484134ecc467d18fe9056fefc6a37ee8a77c6ef86dc247e2c831c4015851bf7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1487bede6d0c9f23f52999007e823ac54d109316e147a78cedd449482bce59dd

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
