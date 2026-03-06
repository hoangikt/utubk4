# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:74f50fb800086b58904e3605e76bee59c9f123de5cde50c01c432240838d8d54 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:b65973b0b3fdbe76fd5cfa97632367690a069989967f6bba7ad4a4f67fe38ef0

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
