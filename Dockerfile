# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:422994bcdf2ef4258eb4fa5b350faec426c2f3c5bdde3c9181affb33d309ea37 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:17aa8b20c264a7a352f0885324c22bdecb10efc5021f846e9a0fc881970fc0f2

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
