# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:628d2c89b7f123ff7352b987be4140c947904a5d940d9c1a80b7afce00db9d66 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b14c51dcd50db3f476eba232515c9e343058a546c766873991af1e4726f8dbaf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
