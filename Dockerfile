# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2f258a1671792c59c234e3a9b25b3cc3f58503be4a7350872c6c950614c941a4 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d2711a21a494fa5c2efbfcf4226268395bad5d03406083ed0f3e7bed5199cfb2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
