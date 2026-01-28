# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:05dcbb48fd4660c0f8b19f1a3109c01c48b66bb59ca880e441de4905bed14a79 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:215e0f214dc7f761932129115eb7d0dc17a3045e4eab4ff4a562334df5d2b709

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
