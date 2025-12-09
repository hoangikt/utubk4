# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d668d153281dbec86a6a16adbf1706cba57a5f892d7bdf03d4784e07572d558d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:255be8dd1d69d0a704d7e8c0b9883636116fc1a1fa929700c5fbbb236714419b

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
