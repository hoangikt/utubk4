# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:041bd8c87c20ff8bbabceedf9f3edd0d70530290d73a53b7fd040093238edbe0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2c6a2e8bdeb1336cd8545d3586d1c1e5b4f7564ef00924b0447ebfbe57a549ee

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
