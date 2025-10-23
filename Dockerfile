# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:07ee5148c6a37f391f1f691c073dcf5254617cb01a3ad8c29eed82d5f8d564b7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5e8ade02dbbcaadac9115af4250af653f97f64849805c668954bc203ad76748b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
