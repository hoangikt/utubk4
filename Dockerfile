# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:73a4170142047ef73517e2245b66bbf83296348fa886c449084e0fe1bde0d657 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:f4179a5be98b1a10d95d1cb9b5d8f83ea4b88da651f940b26d73404c327ba07a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
