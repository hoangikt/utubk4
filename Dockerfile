# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ced54f3ff5a3bb08e7381ce81b68bfa38bd3f5c3dac5b4ee83da80605759ac8d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:294a4d97c5c2c48d5aa3d5c527be59ff838dbe39911088a5f3869accaf26570f

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
