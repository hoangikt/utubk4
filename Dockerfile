# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6611f09b165b0ac0ff31c2ae2ac6fc7960483dfc568a7ee4f1bc4a59777287a8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e2ade4461c3ff67acf054214645e0b4e41b99140d7096ed64c1e15f6fe985cdf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
