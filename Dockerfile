# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9b5e3a4988778e3b756ecbf893eabdb613a36053fab89c1ad989757514159b1e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:203cb459e79dbe45435e79e19f20a57553855628e73b7ebf77364e716a5b64c8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
