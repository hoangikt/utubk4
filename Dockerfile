# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:9ae6d28d97fbcd7586ca8c5db77593081620f9f1cdf92834b3dea511417f06f0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:afff737e54552bb2da99773de75cb783f6c8c3285009581592f5b9e6bc4ab1c8

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
