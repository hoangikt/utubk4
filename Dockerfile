# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:ef5d416c769204462bf6a8af9b4ea327a870fdced32c5372ac43c4ef29dc614c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:679d04611404a759ea36a05d4d09ca35e632fdc6dd47d0b6566706825540b106

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
