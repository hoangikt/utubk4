# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:316dcb52b594ca1b54557cfe41fa66efb4e5bb61ef8b5f262157fbb614cb5f9d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:38ba1cbf71702bacc5f5be22ea41e3d4ad1bfb2565413b0caf4bafde38e831f2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
