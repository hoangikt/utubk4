# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d0c4d53aa4ef455b60a9918fd680bf80b82151e2e56c524d8931ffb8115865bd as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1fa5b8de4d71f79354c71b5f8fd3cb591f51e41dc9e9d620eda2526d1e57a221

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
