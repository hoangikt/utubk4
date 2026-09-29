# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7e3a3c3c8231458251910f5631d84f9d749d370e7317f5b84c5208fbab8bbef5 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a1775c7276078865461ee5714954284f12809f333433d856d720b249c65c11b2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
