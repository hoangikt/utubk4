# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:770e5a8712f63e81753ff2e8c0ed0e88e1cf06c103628c7e6b1277375cbb412e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b61933c15b9c2e9bc7d7913f7ccf97beb766b0b8b2f51fb08bfeef153f8bdf7e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
