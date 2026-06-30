# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:90555ca52ffe2163ec7db49a8d8ee738f6e1c31e50729ee2c05cd4ad5f6ce043 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:5d24c87a044aa2597e12d2788751f138460653fe88a638eb456dd6b9b6a5499e

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
