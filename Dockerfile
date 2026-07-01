# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c3898a57639a93cb4356fce37d6312f8e9ad44ced420f530148dbcbc5f6797ef as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:77d9f82d47d038bbda974e237ab65a27fdc37fe470189064612ab11b5178eb51

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
