# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:c1d5e091a4b83fe3bf5ef09cf53884573a7d094e41f83456bf9b59066286179f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:d62bb4e8348fab86f3e1a8bd40cc21ded21ef325bed2d0eb15c44ec293c1ba70

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
