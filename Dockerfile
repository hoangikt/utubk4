# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:37bdd0309604139f4a3e0e32d8308f860d30ff22bf504df98b87e40b70614661 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:118cb4e86dd4277423720b67003cccea887a1fc6c99007466492c2119bc4d60a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
