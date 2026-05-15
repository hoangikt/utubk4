# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:97d6ff1ceb5be3de80da4e1ecc61e625b39c300c03bf795fc4cae4399ae5044d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:1cb3c5da9785e2f3b13bc46450686ae69e688038c590dc5247b7a98e578ec6db

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
