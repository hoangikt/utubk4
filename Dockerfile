# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:29ab100be9f9be1ec5e31d7b7c384134171ee8f052e24e2285e697538c199aa6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:31dd69d84fe5235fe18f8ceb5b76620e6f44a0ce1f9b0d3a46c491576f8b453b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
