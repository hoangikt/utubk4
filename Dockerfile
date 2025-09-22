# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:f0342a9d65009acf1c72146a7a1ea408cf4d65b3adff2dcbe23a736056b115cc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:7a17326be63f9a7c4f1f7bda460e50c2123c18508afdbb6634e0f24085680425

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
