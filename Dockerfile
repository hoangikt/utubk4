# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:92f81ed090f89c04da8af63cf245087cfca7ebf0fa5272f6f03bb494c2696c86 as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:dc6d95fe490f76869974e1dbe96d4db01c06d194030467a9501584c19466bb30

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
