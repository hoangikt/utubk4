# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:22f5e61aee4674dbab203655a7a4530f4f7a9e08b81ec781e68a8c3230ae07f7 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c61c2d11da44d85e79d8957bd1d21ba4b0313e96801b460bb3f44d256e5beb58

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
