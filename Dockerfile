# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:eaac683e334f7e63235fd3931e24366f7e1a66b963a36e17e20a0da9aaa59108 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:15c25640085de8df6ea342f0f4a0064b85ebb5c6e1fcc306c59f78724c070c9a

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
