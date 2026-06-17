# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3365f2785240c477a4034961fbcdcb96feaa4e4f54432c56e87224b940bd0553 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:37e0742458293f7bfa45573297955574ec7430c5fc9c02344e541706e20f2007

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
