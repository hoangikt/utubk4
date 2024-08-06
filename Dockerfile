# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ede036bd6cac024a9ab1c6fca3a324f4dbcfe82f67f5c3b7bf1fbf2ef9f8f0e3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1e753aa0ea651af8aaf7dd675d9dcfc2139bf13acd2cceb2dba3c39286a6172f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
