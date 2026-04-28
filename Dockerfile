# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e14293e9cd74fef99ff9d65dcb4fde69d79f7a7f7b69bd89c9d49621cc9c1feb as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:621ab610c0bb3478ea8db09eb77aa108d61664edf33635b8dd5da8c940df57b1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
