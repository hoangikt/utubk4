# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:d4343b9cf9ad2cf2b65d85f64dda3d25ee0323c6fc726db5a5e3472183fea880 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:73d190f98ad153222ec562056fd8afd710b0d513d6015672e6198046978942f3

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
