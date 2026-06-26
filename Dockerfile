# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ab6d1f3878d9fc96786ed514ba5eac69170e51c983f9686d5426e7aee3a6077e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:79dc146af52dbbaece4c9aed21bec2579742f3f90a222e9e5bc6f976cf508189

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
