# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:261ceae8cf0ee5055341cd5c417984a70eb0e1406f2ddf83a4c93002bb10c26c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:89281daac77a3d91ef298d70ce3b7a6ccb2ebf268c084fa9a9bda1c92e71c64d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
