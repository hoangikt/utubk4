# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ff02fdbf8b82c6d86be37f4505954dedd25a23290f88cee414b5a9a47d8202c6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:07ab4ab687c10ce194df7ca1a1b2972473bb3f24d05798f509bd6fe41858ee40

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
