# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0dbec28ed9fdf1f515cd92262852f08b5c957ed281494e47b24341ed6c723b5c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e57e10d5d66dffa858fabd4cebdb8a0b5a3d02a40c76e87ec2d13a87de51e521

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
