# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:845c4c458aafc14131ca45be9d21b03f9bce55e7b99b91bbeac874935682ad9e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:69514cf8cb0df3472770e225bd1c0fc7617e1f1eb4fc59447922a2ba4806b04c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
