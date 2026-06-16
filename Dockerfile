# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9809c9624a29c73b46b269f8e0c40b038d799bbed54ee1defbf1c413b88484aa as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ecbfc63dc956d9c0b7e0af0990e6563aa40449815237476996cb54bfeb7cec2d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
