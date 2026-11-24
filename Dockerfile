# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b73b9e61fa9e0c6ec59c68ee2db1a08a4a61b969dbe03a39c309033749ef7f78 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a76d3a2d5a7ba23ac51e1de1d119796142888aeb7d8276b53c7abbb919e3dc5d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
