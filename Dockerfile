# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:e51f00c88b6dc695e822b75cb403e40ab9459bd66524ed0f476dfc8366de8794 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:012106301931c182063868dee31dc36a0d278267ec837176ba1774a320fa1bbb

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
