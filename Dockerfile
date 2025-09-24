# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:47915cad1b9d51679fdbd6e29d0a3e07dd37482c5592a76f7257ede966394248 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:afe7b18d32e6f243fa69bdbbb95f568d668c5c42b93e88c19d30ec24f213d31c

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
