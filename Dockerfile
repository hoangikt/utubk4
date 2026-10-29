# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:b12d43491dc1e7716c76a2eeba0b821ccf368ebecf55944cc64df34eeba4db48 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:549f3ba5e588ebab80dcf5a5a3536aa7f4b5c384bc6955c0347d372414197386

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
