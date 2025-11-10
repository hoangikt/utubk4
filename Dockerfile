# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b827e712d2758d10e21b44f71aed260ffb2c1e42ce695b870628ee9b9142ab6c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ce8cbd5047393b5c7d6e0f27c89f2adcfc5c2dfdcc755f85c3937f684e7d9875

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
