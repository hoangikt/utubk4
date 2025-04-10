# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9a39654a9ee5c6ed6873ca4d76371f6e15b45543da70fc017a1385aead5d71a6 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ae85bc17424cbf379920683c7d8db82612bf78521372bc81b26d8a5a89418aa

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
