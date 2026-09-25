# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2d5551e22013aa1bb69c070398273171941c4a0d80414e7f786db8e6d966bb83 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:992f13b3e2f7d7bef9b0d74caf7d05c12329482b7b1455fe0bfc6531361b9b7d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
