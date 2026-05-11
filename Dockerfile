# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d1dd83447d5113f8b3eeb67c4863db2c8198952ec78fd643c1b3844f0d7cb36c as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6b9baa6cb1c38f515668071aaab304d4f962ae670dd2b98620196d79bd2b230d

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
