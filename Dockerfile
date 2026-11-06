# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a41dd09d107afef6bdd9cc566e4663e504a90f5d5cb6ca7627928db5704631ad as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f73b534b99afc3a17c9d7a863a688d9c2577de23e12af21d55ad7b3fdbaf83f0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
