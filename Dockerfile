# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c32b4d382f5ba56d00630463c3e60f21f8ab43cde11fd8cecefc7419d1b4a33d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:095a1f0d24af7aedd20b72775ad561cda9e36e7d8d4c35793c2e4f95ca0b41f5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
