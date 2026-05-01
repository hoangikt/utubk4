# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:507e6a93094b60ec1d1af0f5fcc88355411ddbb33de7eee31a6481cd2cce16b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:92fee0837e16d9a0a494f61f79ef8304031ada5186fcc7dfe24a9b91790fc16a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
