# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0380fc9aad6698fda0bc01c7b1736501e2cf0cab80db9fdabf704aa720564cca as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e9b40c6d05f57df8351da59ad680a20f65c6a9e5737c456dd56cc1416523290d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
