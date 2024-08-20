# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:392bef95f753d796b3074bb421e78cd1b067c8e18ad5057c70992c81a3b78134 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8ab7150acbdfc4dc445503a67c7f69af2eeba6a9b476fb669bb5b2163826ac5a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
