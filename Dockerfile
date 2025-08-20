# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b9bee41965018f673bddd433eb5f2af977a2fa48c8ebb6ed9a62736458fa4572 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:03ea3f112ff878ace8f7aac31f4c71a66e77efef50d5bd7e62b39547b26cc1ae

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
