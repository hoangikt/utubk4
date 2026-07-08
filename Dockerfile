# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:07a85da651c73a8ff3c0babacbe34e0b48fe4a4282fa206006e2b82c05cc27ba as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:522a5ff629869272271784d864da372e03612822902878ecb20b4afc9e797779

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
