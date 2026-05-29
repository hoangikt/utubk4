# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ddd3811dcbef56aa9f3882ae16fdc2920174ac6028c12e76cfb64c1d37b7abe2 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:30ac20a34bae29023ae54b454e85fedb5cfb7de5f206dc73112bf8b0e3e3e190

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
