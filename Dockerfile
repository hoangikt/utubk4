# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:5568387be3948c73aed1a462163de91e64ae4e0175b9af1f099dd91fe1b60465 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2529543f9cdff43e537d1822f6673a53602d0947f82cd7cd4f4b5d7894ff8788

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
