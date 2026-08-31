# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:30cd0d997b48b7bc5c1c0cb2d88a4cd00e35d68c2babd783a08f2c896628223d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8e3a8e17c9ab20b463f76f62ace70fe55d9b10217b943b26f5b46422ab4936b6

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
