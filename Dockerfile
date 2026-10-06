# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:8c06d75b497c156bb7a42fedb6480fe2c1865e93538215e4a0f7bf99a03f1f99 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b7af1ae90e2fcfb5c32be03908e74d32fdfd64156c2b7c535bd3e497e7846d84

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
