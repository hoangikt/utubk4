# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bfa57b0e812295420c4839d30be0868d4a466ed3c6fed009cd0b5f82bb7e88fd as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:872a42d369a6d9efba17ff4ccf4c0ec103b9e511e5f77793b0f558b933e40929

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
