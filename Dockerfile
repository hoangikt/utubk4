# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7a568bcee42666f73f041645a41c913ce1d442f4c24cf6019bc543a90820e531 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a0365f7b90bf7b78a5e35f2709efb7c9263acf9c7b1905e0ec4c3e943c88e64d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
