# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b619f038ee69e0c070515b3d512e15b260c14e863616f50a6e111fceb25d137e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:2f35e05f55378119cdc42835a067df87b8e74281ea71ef6565447b398add45a3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
