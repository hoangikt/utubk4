# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:dcd049fc09707da7ab965c559e690f5536675152c931ca6b9281b0c13bbc235b as builder

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
