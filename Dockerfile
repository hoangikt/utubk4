# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:16ef9480a72a9e1f422ade7c60c7d4d4a3ef258b676ecd223ae137972c3520fc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:90d81f1d75d9042571a6776b89763678f77fae44e399baf823466091bd494b02

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
