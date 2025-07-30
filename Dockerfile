# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0f56f36b195810bb0a935a9750f5191f451fe1a8f4f0fc80dc1f0344bfdf9b01 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e7dc21120d9df2ad36b5b25bcf307ce62e7168810a82c7773cca5c9495339c8a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
