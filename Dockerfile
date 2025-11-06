# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b5138cab80776c4012cf1170edba7eba2f1eae2a4dac69e792a10b8d10543a69 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:68c4e12a9c86c0664d33ea286b0bdebb16ce858fdbdbc81936fa2c3d47375a64

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
