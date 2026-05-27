# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:fa24a5125b01a963dc6fb23972a621a0e54b8195698c7d893d54e688e267e7b3 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d418ff2362e75d3343bb6d59c33618a5b03430e04469a73c34cb8be9f98419db

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
