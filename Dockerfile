# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3472bbd8c7a7fe9254dcccdbd8eefb8edf603d0882aa4ed527f8497957b10f5f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:27c8d0e215a516e6d366549d1673baf6c42784277afcc8d904715a73982b9ba4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
