# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:4fc64fd3287508c92a29498852ecc52a8d5fc9bd18b63b3e9a22256e0751a8d0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bb606a2afc594b820a217ee76e7f59651922316bc706ab57a96f6ef3a9356634

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
