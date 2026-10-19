# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:905b31747ebcae4242e0b71fcd2640c712b79a96f929811d3202b9716b66592a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:26a608c1549ee52eeb717bf66bce5e60cebaa4a0cd2a57774dfd49484bd38c9a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
