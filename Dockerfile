# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e6b4a7790b9f0077bbd034d072bff0ee1336b7bfd96f0738e601ad3ff98ea1a7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:af9f881767681598970f2d4316ffe1f42abcb0413282b555bf7ce9b0774a7c79

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
