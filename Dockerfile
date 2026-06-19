# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a38c998396e846c009bcabfc70702f64205b8db1dde71c8c8e5e734213afb237 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bbae4504f6381ba41b65111ce3bb229a7c4f4def6ac400576705044414a09001

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
