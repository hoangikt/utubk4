# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f475abdba3927df9fe2b87ca886b6b2a112d0a1f196617bd85af07928df6d773 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5050e88595e02879be85d0c1f9f8f3ffc743d8fe925d9b4c501df95e682ec5d1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
