# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:a690eb16152f19947af02d1d8a6092d352881bb253bc91177eb04d112bddece0 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:e47c748a643dc09d98587839d62ae8b76aa2a192af6ec6506fa6a305901b7810

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
