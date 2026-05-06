# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e28e4cb5d25e89524057047075b0c31d03ea4d2a83b267b50a46cb972dc507d3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d5621d0d63e5212f6ae9fd612c6d2a72f65155f978538f984a7a0cdafbd7cdb2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
