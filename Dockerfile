# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:66ad90451e4b930d12fcf5cdf7d6a0cfdc030c4ff0f3cab4065a4a93a54b2d72 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:695359b1e5130bd27e8dab298c8c51c1fb4dc3023fa91eb895ef8b2696211328

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
