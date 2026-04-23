# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:515aa92ead0f164fd40cc08036232839b882b7d7211f74e0701268e875d8a80f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:38d228c184602f2b85a7072d772b9de07a9d082b3e9cf526e3f3a10f8710668f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
