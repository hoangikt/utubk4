# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:171a608fb79f2807fe9ac9ae60f045820976aa27f442e434e5c8ca72671b4bac as builder

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
