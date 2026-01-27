# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:698abbe8777bcc5b370c6c198c48a7aa86bd418c7234bbdae1fe06235cd121b8 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4171eedf8acce898abcb5c694a42469834cf90f4fa83beaefa180db7ed023cbf

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
