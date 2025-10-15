# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:20252c65f85d26ac56aeb2811e7a08afbe24c276d9c935cd10711fd417a8bedc as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:34c0aa496379c56dc18bc0e1771fbbe4a5da33543c22e2c1468d6a76f14e3680

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
