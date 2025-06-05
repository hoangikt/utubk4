# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:10d79a652cabefda086cabd4a6a70d301e173b949bef45e30b8174675d783ff4 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:08e91d4a86cc9e39829b867b0722234a6440b8ff9faedda57e542f8bf8c2b0c5

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
