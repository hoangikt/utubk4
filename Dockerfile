# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c2c7e0ae49478c1f12bf9311602e32df2fb6ff77f272412d90d0071821923383 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8e1d8d13a046fbcab6ac1f68a0887d737d96c4355aab8e3d3031671a465ee047

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
