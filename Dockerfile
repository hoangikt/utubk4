# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:956b11e7b21e5f668b8389e0284da44138e3f317b2dafe604115873d9bcef6f6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1c4deeea85db49ab5f6bcd9e7fc0bf3fd8439e99f7bde45330f40400685eb394

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
