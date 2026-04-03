# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:3bbdbe97ec60f27993d6447cc9fcc82b2d2c25f3f31afc6d8b29be3049525a26 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:69073bb3308f50da8d56938fe5f5937a244f6a711726c4faa58e4c033b9a719a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
