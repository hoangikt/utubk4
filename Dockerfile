# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6958806e6fbc6bb7fd5fd2727b4f6d750d9bb04b02ecff526a90a58d2da098fa as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e080491bb0eb05cc538160fe476f36c7b1ae4fde454ec173677a0e32cba89b26

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
