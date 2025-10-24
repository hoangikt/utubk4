# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:bd1055ef75f6147dec8c8259ce44f3134e8e59baf46edfd41ed19a75b842e545 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b1da912e82db2c234f15b34c90bf00fc959c52d07f9b2787bebdebe844f5f6e2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
