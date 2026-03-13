# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:eb1564302c058084c0559bd8ffd0a93ed5cc9bfee7dc4889d40633f08e4e3099 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c789723622cfc4a6b5d604a59250e3f708d0b4bb64cabb39a17c47119a224179

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
