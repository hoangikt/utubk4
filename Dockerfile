# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:524b6b99340e6f80a06bbb867369717d2153addbdc8028a9e6bbe0f62085ab4a as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:cde301cd5f4e494b3ecb1d5b0c8370499482fbefd112b72afe87d4e6f29a0bc1

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
