# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:7e5c405e063dfbd4fdff1d25208da787b1627c36d31f4761285aad86d0192d7e as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:9ef8bb158785da794a20eed32aa25a11283312974a9f772c06bb91e0b91c60f7

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
