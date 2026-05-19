# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:866419cbf80d962a159689e82e1127cdec06564db23bd2dbc10f629bc404c060 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:54a8ebe6bcd5e08e2ddbb8266168846688a95a99019571d147702d7774c75cd4

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
