# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:2ab99faf5bc020c65c7b7ba049936d342b9104438405b267914f3d4ea49d1312 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2e58390ef69549a4d2cb2fe3f192c84f407995bf3d126be448bc150d41b82a00

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
