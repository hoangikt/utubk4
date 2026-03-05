# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:269ebd2be28b2709f5cb6a16cee323b59a92d29d23b676ec869a232687cb40ee as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:6b75c6363142679d082d3aed51280bd7eace8412e9ce7ab8394e38fc80ae9889

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
