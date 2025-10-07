# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e71ea77e3584e9a776cc7f013285b6e019f356851534bc62901fad34557a719e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ba57d249a2ecf076795604b522e2a2945031bb70607e45e09e410e9b8207b715

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
