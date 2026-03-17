# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c65a2a847876717a077f671d39d83b6e0581de28d562081f8189f7615c87ca24 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b720e8333748d1977a6b7971fc85c6bd051e7f7863149c3fa03b460166658ed8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
