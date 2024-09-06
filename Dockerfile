# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a8d76ddeca2488dbbe26fed1d8be5813783372b93558c642f7ae39f8a8d0bf32 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a0ebbd2710712d947f80bd508d63d7a15da99b988c4a60ac1b7c015c51f511c4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
