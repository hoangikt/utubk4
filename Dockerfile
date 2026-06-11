# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a83db17f9a2c4577023d851af68b8ebc1abb38d508658691e5220e779a44adfc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:a2f5cd5216fd417eb245e45f4c0519a86e95ccfc42126a874f7b26f084cec5dc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
