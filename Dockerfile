# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b3a6903df91866d99a27d791bcc544d4c9d11ef029792dde8a89e7fbf175a444 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1873824295b959ab33a1491d78ff96bccd3aa82c058d5685341fe638e02e496c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
