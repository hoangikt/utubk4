# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ab3dc2c3d1db9ac2e5c15987a6064dec45a8ea0743ce3930614305cfc58d8c69 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:12c034b67f24b85db97913589899a5418438e1d9fbe0dbce8abff966ff2bf62a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
