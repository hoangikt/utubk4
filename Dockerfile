# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bcf9a01e247084ded7d43764387f96db8a33f798f0ecf2d5be90cd9d67a7d59f as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:292095443fbb5bb18a7fced80b04f6f330e1873e0be0e21d360f0ecd4dbedcf0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
