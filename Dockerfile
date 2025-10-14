# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:edb09510fa6f7b8b4876207346a85d62d3b02d1ba896f1c44b33e07fb91fc94d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:22a86d2fbc27fe5c4c06fc362a94e4fbf7b4fde6c3c49462c8d3168e340fbe48

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
