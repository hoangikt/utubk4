# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6a2f9c5a2c2374c991f08eeed2ee1fa8fe2b61972b8a05c5a020f172c3513a5e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c8e464ca00c86bd80498e0e509120b0d2dadcd9655dcc31b0efd0caf86465253

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
