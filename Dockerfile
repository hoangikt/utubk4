# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f9e40c2b7bc96e56ef1bc168dfb7cba4e9dca215b84d63063c799310bcb16751 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bd849aeb63c12208ea68faa568c3874737cdc4d3742619d27e33bfb980c5772c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
