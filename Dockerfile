# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:03f3982a4dcacde8c200a200da8f6275311055c57914f68fc756b661905ff018 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:ffc3de748e31707704da3ec6566ebaf420a7d6a072ce3ac7fbb9491a6ac69ffd

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
