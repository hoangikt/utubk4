# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a42d719241118ca2554cbf59f4b0e3d20f29ff14c32e9e7f5ad3a8c812a73777 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:c8982fceef8e20c2c721789823f752517b57fbcbbe4641cf49f69af560a7bc22

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
