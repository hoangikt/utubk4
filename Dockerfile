# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:073219a510343c070f74fd1fd7100b9e599cf68eb1536be8ebd4c0b170ede589 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:3402da0629d26501855f13d490b7fa1b525e4a5db3a10af324277e5507fcb8e6

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
