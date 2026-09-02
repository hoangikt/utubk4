# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:30c33361f26c0823f3a4a414f27802da84b390b5da53ceeaecaffe5d89dc3135 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bfd60ee44e9a4d855c6dad9a31c6b98e67d4f4e21e9ac9f3b6c30ef9a830bd00

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
