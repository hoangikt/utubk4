# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:84e682a997dfc2aff264242871c2a3301213c3a23002bc11c0c432d67fd012ed as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:8913de1dc89781c551a5298b9497274807ba3e418b49b7a1d4c7836cac0db712

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
