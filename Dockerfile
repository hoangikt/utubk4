# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4b667393d6f57c20aaf7d6baf4b33c4cf3923ab8ef5a64b532cffaf114d211c6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:128a83f2371127148a2640eeca299478ee5437f1c27a6d64d9c66ac9dc8d0252

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
