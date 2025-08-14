# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:09f48e1aaf01887e8e25d699aac02f3352841d2b3a3799a30481c8291ab0103c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:17cd737bfcfd3fd8b7a32036dcbbf80ae9e85c503f0b46d755e31208a46a392f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
