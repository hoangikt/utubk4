# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:0d71896f391021f6ed626b9cf59abf6eced0444b5bedb4d1bd24ba478ed5132d as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:081843ee8d42694f0b113aa166a2cbf16c543ba9a89cf554b6f7eb5b00e64a72

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
