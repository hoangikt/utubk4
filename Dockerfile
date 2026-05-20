# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5b542358ae4f8a121f9b81661c449a83ad23a587a7d5fe2a530d7b3771b2dc5e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e4ec7051aae87617182379ef05c33ad757fbed85e804c5e07e9a2d1778042ae5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
