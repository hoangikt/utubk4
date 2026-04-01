# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7f42e64e4e4a56c1290aa6cde94f94a295c6d67334805b82e49356102e8d6b63 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d6b479bba2caccce8c7a3e0b2f9c495740785f532d00b2d2fecac0f0dee40287

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
