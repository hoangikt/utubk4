# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e54c972c4097045e913eba44bf0c29f85cc9c64190e6355f7a62743379be9f94 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7e8d50cf67683131e6d8cbad3a95ab1b960c2ce815f24a2f4527f48a18d7b323

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
