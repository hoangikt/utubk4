# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3d1f8858036c90e826f267baa1abbfd1b59e16d23b0d58ee8d84f4f216375702 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e1a792bc1e72e6395fbf0504bd040945df8999e3e0b22728c279767f771a04ee

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
