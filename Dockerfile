# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5f04e7637ccc7e2460eb5abfffa7536ad5c67ac67cd90ab1f2c80054c35ed028 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:270ce628688ea2cf09f24f7eac2435a4af59598a3a642f23386035489a410dc2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
