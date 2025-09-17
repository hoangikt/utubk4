# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:12f318dd067c0633a4509a92167e30d70e5d42e2164b0b01c11ab89acb6c611d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:207bc5de92a7c45e5e4bc1fc40936f6b56f7aa34238d7ae3b93456914ccc3d69

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
