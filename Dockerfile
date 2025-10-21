# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:59636e95ab458cc97d05fb70a4577d7f9818420a713449ffd4a87e609319a13e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:df07729a6842572922ea04b17580ce397f141fbfb9f88265972a840f5fbc567e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
