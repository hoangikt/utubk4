# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3b0a31d5a6b5bd6169bc217fbdec71f321ef99446964e8d19bd540ffaa067638 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:37e0742458293f7bfa45573297955574ec7430c5fc9c02344e541706e20f2007

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
