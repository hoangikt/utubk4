# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:62dce7cededa1d3e50394d30b33e059a3b7c3d21187fea35bab4419abb245420 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:136aad7020e00a98f617f3d3343cc7601b7823405eb2bc581eae5f5a8c21e8d0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
