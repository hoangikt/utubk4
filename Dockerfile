# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:32cb95ea61afbc761ba76561e9762196efabe9c0f59010e03768ba5dba9dce1f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b720e8333748d1977a6b7971fc85c6bd051e7f7863149c3fa03b460166658ed8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
