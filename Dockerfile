# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e1e5f9b6eb7171d0830343348a1fd874a24f05d08d08d190d4633c2655ea7d8e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:12e3eac16cf54bd4aeaaace63525bad4577ac5f2c53cd7c3c4c2cc784963466e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
