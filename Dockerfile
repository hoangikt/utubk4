# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:017628f56563a770f0bb772164884c40047e0cec52caee3356689b1c212ff2b5 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:15c25640085de8df6ea342f0f4a0064b85ebb5c6e1fcc306c59f78724c070c9a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
