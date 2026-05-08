# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:6766a166e2a242a14d3b1505fca8de6c81825ee361cc850fa0e78b01cc738f32 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:daab958311b820bc98b7896df8e306ddb0c842b934453c91fb540008b1684f0c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
