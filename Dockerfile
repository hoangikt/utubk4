# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:8e3b0c5fade3f65ca491d5ccf883ed0f731f4fe9939b39009d727d365a266e1c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:91d2e7e325288a456ebf239270fe91a14bcf1c04f931d1d04a8cb0569346b883

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
