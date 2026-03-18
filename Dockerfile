# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:1de23ede51b7ec4674af61b8c937c53f5d67ca79d88c6ea8f4ef2a12cd57944b as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:65679db7c6f5122377025dba932ecc9d6d8e3a8902a98d6b1bbce58821319cc8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
