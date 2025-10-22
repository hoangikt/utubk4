# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:8e01369050822ac87b5c2167e2d7a527e9ee9fb014336475591ed64a0cfdc68b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c651f2db0fa2e2f08fdfe87a91385f1084961590d3a660d2e22ce61f46774673

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
