# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7e19f3a10fe87a502e9e1bc39e3fb917281cd72dabec34d70bacbe2d7d6dd63b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e23e5598a0770ec4a9bbc5dbd9f157f097b4825c4508914e36acd33454484535

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
