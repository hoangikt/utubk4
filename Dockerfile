# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:26efc63356f36e01b6b4bf4b09fe248396a0f87b088cc129b71b54362a0ef398 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:bafd6f43f4fb7a0270e06a0b3a140baf29fdf79693c903d2ed5e95f3d71bccda

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
