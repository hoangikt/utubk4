# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:da16a852e53e8f2ad0f7b96812e1598d36635c086e7d3883fbde1f9f249b75b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1c605c08b30dc8145d27c3e11964d3bfc237a5f96607e1d4fa338048e617266e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
