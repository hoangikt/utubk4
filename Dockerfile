# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c3be397764bbe1a388a8bbecf84e496a26bd60b9db8d158ee810a6e8cd84e299 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:965525598ca081814d9235c7c7fd712d819f9d4d00cfe57ef9a1186320f44ded

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
