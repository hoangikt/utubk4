# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:31e6df730a83fca0b81062edee476b035a1034e036cff73fd561242f8e6086d6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8af8850acf2827e9b1e140758359900c6270344a4cce8725cfefae92b3c7e328

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
